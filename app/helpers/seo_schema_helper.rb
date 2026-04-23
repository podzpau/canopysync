module SeoSchemaHelper
  PRODUCT_TYPE_CONCEPT_KEYS = {
    "flower"      => "cannabis_flower",
    "pre-roll"    => "pre_roll",
    "edible"      => "cannabis_edible",
    "concentrate" => "cannabis_concentrate",
    "vape"        => "vape_cartridge",
    "tincture"    => "tincture_of_cannabis",
    "topical"     => nil,
    "beverage"    => "cannabis_edible",
    "capsule"     => nil
  }.freeze

  STRAIN_CONCEPT_KEYS = {
    "sativa" => "cannabis_sativa",
    "indica" => "cannabis_indica",
    "hybrid" => nil
  }.freeze

  COLLECTION_SLUG_CONCEPT_KEYS = {
    "flower"       => "cannabis_flower",
    "pre-roll"     => "pre_roll",
    "pre-rolls"    => "pre_roll",
    "edibles"      => "cannabis_edible",
    "concentrates" => "cannabis_concentrate",
    "vapes"        => "vape_cartridge",
    "tinctures"    => "tincture_of_cannabis",
    "sativa"       => "cannabis_sativa",
    "indica"       => "cannabis_indica"
  }.freeze

  def product_schemas(product, shop: Current.shop)
    [
      build_product_node(product, shop: shop),
      build_product_webpage(product, shop: shop)
    ]
  end

  def collection_schemas(collection, products: [], shop: Current.shop)
    [ build_collection_page(collection, products: products, shop: shop) ]
  end

  def brand_schemas(brand, products: [], shop: Current.shop)
    [ build_brand_page(brand, products: products, shop: shop) ]
  end

  def shop_org_schema(shop)
    node = {
      "@context" => "https://schema.org",
      "@type"    => "Organization",
      "@id"      => "https://#{shop.domain}/#org",
      "name"     => shop.name,
      "url"      => "https://#{shop.domain}/"
    }
    sas = [
      shop.try(:social_facebook_url),
      shop.try(:social_instagram_url),
      shop.try(:social_twitter_url),
      shop.try(:social_linkedin_url),
      shop.try(:social_youtube_url)
    ].compact.reject(&:blank?)
    node["sameAs"] = sas unless sas.empty?
    node
  end

  def home_page_schemas(shop)
    [
      build_local_business(shop),
      build_website_node(shop)
    ]
  end

  private

  def build_local_business(shop)
    node = {
      "@context" => "https://schema.org",
      "@type"    => ["LocalBusiness", "Store"],
      "@id"      => "https://#{shop.domain}/#localbusiness",
      "name"     => shop.name,
      "url"      => "https://#{shop.domain}/",
      "isPartOf" => { "@id" => "https://#{shop.domain}/#org" }
    }
    node["logo"] = shop.logo_url if shop.logo_url.present?
    node["image"] = shop.logo_url if shop.logo_url.present?
    node["telephone"] = shop.phone if shop.respond_to?(:phone) && shop.phone.present?
    if shop.respond_to?(:street_address) && shop.street_address.present?
      node["address"] = {
        "@type" => "PostalAddress",
        "streetAddress" => shop.street_address,
        "addressLocality" => shop.city,
        "addressRegion" => shop.state,
        "postalCode" => shop.zip,
        "addressCountry" => "US"
      }.compact
    end
    node
  end

  def build_website_node(shop)
    {
      "@context" => "https://schema.org",
      "@type"    => "WebSite",
      "@id"      => "https://#{shop.domain}/#website",
      "url"      => "https://#{shop.domain}/",
      "name"     => shop.name,
      "publisher" => { "@id" => "https://#{shop.domain}/#org" }
    }
  end

  def host_url(path, shop:)
    "https://#{shop.domain}#{path}"
  end

  def seo_collection_path(collection)
    if collection.parent
      "/collection/#{collection.parent.slug}/#{collection.slug}/"
    else
      "/collection/#{collection.slug}/"
    end
  end

  def build_product_node(product, shop:)
    path = "/product/#{product.slug}/"
    node = {
      "@context"  => "https://schema.org",
      "@type"     => "Product",
      "@id"       => host_url("#{path}#product", shop: shop),
      "name"      => product.name,
      "url"       => host_url(path, shop: shop)
    }
    node["image"] = product.image_url if product.image_url.present?
    if product.brand
      node["brand"] = {
        "@type" => "Brand",
        "@id"   => host_url("/brand/#{product.brand.slug}/#brand", shop: shop)
      }
    end
    if product.price_cents
      node["offers"] = {
        "@type"        => "Offer",
        "price"        => format("%.2f", product.price_cents / 100.0),
        "priceCurrency" => "USD",
        "availability" => "https://schema.org/InStore"
      }
    end
    node
  end

  def build_product_webpage(product, shop:)
    path = "/product/#{product.slug}/"
    concept_nodes = resolve_product_concepts(product, shop: shop)
    about = concept_nodes.dup
    about << build_org_node(product.brand, shop: shop) if product.brand

    node = {
      "@context"   => "https://schema.org",
      "@type"      => "WebPage",
      "@id"        => host_url("#{path}#webpage", shop: shop),
      "url"        => host_url(path, shop: shop),
      "name"       => TitleGenerator.product(product),
      "mainEntity" => { "@id" => host_url("#{path}#product", shop: shop) },
      "breadcrumb" => { "@id" => host_url("#{path}#breadcrumb", shop: shop) },
      "isPartOf"   => { "@id" => host_url("/#website", shop: shop) }
    }
    node["about"] = about unless about.empty?
    node
  end

  def build_collection_page(collection, products:, shop:)
    path = seo_collection_path(collection)
    about = resolve_collection_concepts(collection, shop: shop)

    item_list = {
      "@type"           => "ItemList",
      "@id"             => host_url("#{path}#itemlist", shop: shop),
      "itemListElement" => products.first(50).each_with_index.map do |p, i|
        { "@type" => "ListItem", "position" => i + 1, "url" => host_url("/product/#{p.slug}/", shop: shop) }
      end
    }

    node = {
      "@context"   => "https://schema.org",
      "@type"      => "CollectionPage",
      "@id"        => host_url("#{path}#webpage", shop: shop),
      "url"        => host_url(path, shop: shop),
      "name"       => TitleGenerator.collection(collection),
      "mainEntity" => item_list,
      "breadcrumb" => { "@id" => host_url("#{path}#breadcrumb", shop: shop) },
      "isPartOf"   => { "@id" => host_url("/#website", shop: shop) }
    }
    node["about"] = about unless about.empty?
    node
  end

  def build_brand_page(brand, products:, shop:)
    path = "/brand/#{brand.slug}/"
    org_node  = build_org_node(brand, shop: shop)

    concept_keys = products.map { |p| PRODUCT_TYPE_CONCEPT_KEYS[p.product_type] }.compact.uniq
    concept_nodes = concept_keys.any? ? ConceptEntity.where(key: concept_keys).map { |c| build_concept_node(c, shop: shop) } : []
    about = [ org_node ] + concept_nodes

    brand_node = {
      "@type" => "Brand",
      "@id"   => host_url("#{path}#brand", shop: shop),
      "name"  => brand.name
    }
    sas = brand_same_as(brand)
    brand_node["sameAs"] = sas unless sas.empty?

    item_list = {
      "@type"           => "ItemList",
      "@id"             => host_url("#{path}#itemlist", shop: shop),
      "itemListElement" => products.first(50).each_with_index.map do |p, i|
        { "@type" => "ListItem", "position" => i + 1, "url" => host_url("/product/#{p.slug}/", shop: shop) }
      end
    }

    node = {
      "@context"   => "https://schema.org",
      "@type"      => "CollectionPage",
      "@id"        => host_url("#{path}#webpage", shop: shop),
      "url"        => host_url(path, shop: shop),
      "name"       => brand.name,
      "mainEntity" => brand_node,
      "breadcrumb" => { "@id" => host_url("#{path}#breadcrumb", shop: shop) },
      "isPartOf"   => { "@id" => host_url("/#website", shop: shop) }
    }
    node["about"] = about unless about.empty?
    node
  end

  def build_concept_node(concept, shop:)
    node = {
      "@type" => "Thing",
      "@id"   => host_url("/entity/#{concept.key}/#thing", shop: shop),
      "name"  => concept.name
    }
    sas = []
    sas << concept.wikidata_url if concept.wikidata_url.present?
    sas << concept.wikipedia_url if concept.wikipedia_url.present?
    node["sameAs"] = sas unless sas.empty?
    node
  end

  def build_org_node(brand, shop:)
    node = {
      "@type" => "Organization",
      "@id"   => host_url("/brand/#{brand.slug}/#org", shop: shop),
      "name"  => brand.name
    }
    sas = brand_same_as(brand)
    node["sameAs"] = sas unless sas.empty?
    node
  end

  def brand_same_as(brand)
    [
      brand.respond_to?(:wikidata_url) ? brand.wikidata_url : nil,
      brand.respond_to?(:wikipedia_url) ? brand.wikipedia_url : nil,
      brand.website_url,
      brand.instagram_url,
      brand.twitter_url,
      brand.respond_to?(:linkedin_url) ? brand.linkedin_url : nil
    ].compact.reject(&:blank?).first(5)
  end

  def resolve_product_concepts(product, shop:)
    keys = []
    type_key = PRODUCT_TYPE_CONCEPT_KEYS[product.product_type]
    keys << type_key if type_key

    strain_key = product.strain_classification ? STRAIN_CONCEPT_KEYS[product.strain_classification] : nil
    keys << strain_key if strain_key

    keys << "cannabis" if keys.size < 2
    keys.compact!

    ConceptEntity.where(key: keys).map { |c| build_concept_node(c, shop: shop) }
  end

  def resolve_collection_concepts(collection, shop:)
    keys = []
    keys << COLLECTION_SLUG_CONCEPT_KEYS[collection.slug]
    keys << COLLECTION_SLUG_CONCEPT_KEYS[collection.parent&.slug] if collection.parent
    keys << "cannabis" if keys.compact.size < 2
    keys.compact!

    ConceptEntity.where(key: keys).map { |c| build_concept_node(c, shop: shop) }
  end
end
