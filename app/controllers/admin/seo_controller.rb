class Admin::SeoController < AdminController
  def index
    @all_records = seo_records_for(@current_admin.shop)
    @tab = "all"
  end

  def products
    @all_records = @current_admin.shop.products.order(:name).map { |r| decorate(r, "Product") }
    @tab = "products"
    render :index
  end

  def brands
    @all_records = @current_admin.shop.brands.order(:name).map { |r| decorate(r, "Brand") }
    @tab = "brands"
    render :index
  end

  def collections
    @all_records = @current_admin.shop.collections.order(:name).map { |r| decorate(r, "Collection") }
    @tab = "collections"
    render :index
  end

  def edit_product
    @record      = @current_admin.shop.products.find(params[:id])
    @record_type = "product"
    @auto_title  = TitleGenerator.product(@record)
    @auto_desc   = @record.description.to_s.truncate(155)
    @form_url    = admin_update_product_seo_path(@record)
    @schema_preview = build_product_schema_preview(@record)
    render :edit
  end

  def update_product
    @record = @current_admin.shop.products.find(params[:id])
    if @record.update(seo_params)
      redirect_to admin_seo_index_path, notice: "SEO settings saved."
    else
      @record_type    = "product"
      @auto_title     = TitleGenerator.product(@record)
      @auto_desc      = @record.description.to_s.truncate(155)
      @form_url       = admin_update_product_seo_path(@record)
      @schema_preview = build_product_schema_preview(@record)
      render :edit, status: :unprocessable_entity
    end
  end

  def edit_brand
    @record      = @current_admin.shop.brands.find(params[:id])
    @record_type = "brand"
    @auto_title  = TitleGenerator.brand(@record)
    @auto_desc   = @record.description.to_s.truncate(155)
    @form_url    = admin_update_brand_seo_path(@record)
    @schema_preview = build_brand_schema_preview(@record)
    render :edit
  end

  def update_brand
    @record = @current_admin.shop.brands.find(params[:id])
    if @record.update(seo_params.merge(brand_entity_params))
      redirect_to admin_seo_index_path, notice: "SEO settings saved."
    else
      @record_type    = "brand"
      @auto_title     = TitleGenerator.brand(@record)
      @auto_desc      = @record.description.to_s.truncate(155)
      @form_url       = admin_update_brand_seo_path(@record)
      @schema_preview = build_brand_schema_preview(@record)
      render :edit, status: :unprocessable_entity
    end
  end

  def edit_collection
    @record      = @current_admin.shop.collections.find(params[:id])
    @record_type = "collection"
    @auto_title  = TitleGenerator.collection(@record)
    @auto_desc   = @record.description.to_s.truncate(155)
    @form_url    = admin_update_collection_seo_path(@record)
    @schema_preview = build_collection_schema_preview(@record)
    render :edit
  end

  def update_collection
    @record = @current_admin.shop.collections.find(params[:id])
    if @record.update(seo_params)
      redirect_to admin_seo_index_path, notice: "SEO settings saved."
    else
      @record_type    = "collection"
      @auto_title     = TitleGenerator.collection(@record)
      @auto_desc      = @record.description.to_s.truncate(155)
      @form_url       = admin_update_collection_seo_path(@record)
      @schema_preview = build_collection_schema_preview(@record)
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def seo_params
    params.require(:record).permit(
      :seo_title, :seo_description, :seo_canonical_url,
      :seo_robots, :seo_focus_keyword, :noindex
    )
  end

  def brand_entity_params
    params.require(:record).permit(
      :website_url, :wikipedia_url, :wikidata_url,
      :instagram_url, :twitter_url, :linkedin_url
    )
  end

  def seo_records_for(shop)
    products    = shop.products.order(:name).map    { |r| decorate(r, "Product") }
    brands      = shop.brands.order(:name).map      { |r| decorate(r, "Brand") }
    collections = shop.collections.order(:name).map { |r| decorate(r, "Collection") }
    (products + brands + collections).sort_by { |r| r[:score] }
  end

  def decorate(record, type)
    {
      record: record,
      type:   type,
      name:   record.name,
      score:  record.seo_score || 0,
      title:  record.seo_title,
      keyword: record.seo_focus_keyword,
      schema_strength: schema_strength(record, type),
      edit_path: edit_path_for(record, type)
    }
  end

  def edit_path_for(record, type)
    case type
    when "Product"    then admin_edit_product_seo_path(record)
    when "Brand"      then admin_edit_brand_seo_path(record)
    when "Collection" then admin_edit_collection_seo_path(record)
    end
  end

  def schema_strength(record, type)
    case type
    when "Product"
      # brand has sameAs + product_type maps to concept
      count = 0
      if record.brand
        count += 1 if record.brand.website_url.present?
        count += 1 if record.brand.wikipedia_url.present?
        count += 1 if record.brand.instagram_url.present?
      end
      count += 1 if SeoSchemaHelper::PRODUCT_TYPE_CONCEPT_KEYS[record.product_type]
      count += 1 if record.strain_classification &&
                    SeoSchemaHelper::STRAIN_CONCEPT_KEYS[record.strain_classification]
      count
    when "Brand"
      [ record.website_url, record.wikipedia_url, record.instagram_url,
        record.twitter_url, record.linkedin_url ].count(&:present?)
    when "Collection"
      SeoSchemaHelper::COLLECTION_SLUG_CONCEPT_KEYS[record.slug] ? 2 : 0
    else
      0
    end
  end

  def build_product_schema_preview(product)
    shop = @current_admin.shop
    path = "/product/#{product.slug}/"
    {
      "@context" => "https://schema.org",
      "@type"    => "Product",
      "name"     => product.seo_title.presence || TitleGenerator.product(product),
      "url"      => "https://#{shop.domain}#{path}",
      "image"    => product.image_url.presence,
      "brand"    => product.brand ? { "@type" => "Brand", "name" => product.brand.name } : nil
    }.compact
  end

  def build_brand_schema_preview(brand)
    shop = @current_admin.shop
    path = "/brand/#{brand.slug}/"
    sas = [
      brand.wikidata_url, brand.wikipedia_url,
      brand.website_url, brand.instagram_url,
      brand.twitter_url, brand.linkedin_url
    ].compact.reject(&:blank?)
    node = {
      "@context" => "https://schema.org",
      "@type"    => "Organization",
      "name"     => brand.name,
      "url"      => "https://#{shop.domain}#{path}"
    }
    node["sameAs"] = sas unless sas.empty?
    node
  end

  def build_collection_schema_preview(collection)
    shop = @current_admin.shop
    path = collection.parent ? "/collection/#{collection.parent.slug}/#{collection.slug}/" : "/collection/#{collection.slug}/"
    {
      "@context" => "https://schema.org",
      "@type"    => "CollectionPage",
      "name"     => collection.seo_title.presence || TitleGenerator.collection(collection),
      "url"      => "https://#{shop.domain}#{path}"
    }
  end
end
