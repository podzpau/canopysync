class SeoAutoGenerator
  # Called after a shop's blocks are generated (by AI or manually).
  # Auto-populates SEO fields for the shop's home page and all records
  # that are missing SEO data.
  #
  # Usage: SeoAutoGenerator.call(shop)

  def self.call(shop)
    generate_home_seo(shop)
    generate_product_seo(shop)
    generate_brand_seo(shop)
    generate_collection_seo(shop)
    generate_strain_seo(shop) if shop.respond_to?(:strains)
    generate_blog_seo(shop) if shop.respond_to?(:blog_posts)
  end

  private

  def self.generate_home_seo(shop)
    if shop.meta_title.blank?
      shop.update_column(:meta_title, "#{shop.name} | Cannabis Dispensary")
    end
    if shop.meta_description.blank?
      shop.update_column(:meta_description, "Shop premium cannabis products at #{shop.name}. Browse flower, edibles, concentrates, vapes, and more. Order online for pickup or delivery.")
    end
  end

  def self.generate_product_seo(shop)
    shop.products.where(seo_title: [nil, ""]).find_each do |product|
      title = TitleGenerator.product(product, shop: shop)
      desc = build_product_description(product, shop)
      product.update_columns(seo_title: title, seo_description: desc)
    end
  end

  def self.generate_brand_seo(shop)
    shop.brands.where(seo_title: [nil, ""]).find_each do |brand|
      title = TitleGenerator.brand(brand, shop: shop)
      product_count = shop.products.where(brand_id: brand.id, published: true).count
      desc = "Shop #{brand.name} products at #{shop.name}. #{product_count} products available. Browse #{brand.name} flower, edibles, concentrates, and more."
      brand.update_columns(seo_title: title, seo_description: desc.truncate(155))
    end
  end

  def self.generate_collection_seo(shop)
    shop.collections.where(seo_title: [nil, ""]).find_each do |collection|
      title = TitleGenerator.collection(collection, shop: shop)
      desc = "Browse #{collection.name} at #{shop.name}. Shop our curated selection of cannabis #{collection.name.downcase} with online ordering."
      collection.update_columns(seo_title: title, seo_description: desc.truncate(155))
    end
  end

  def self.generate_strain_seo(shop)
    shop.strains.where(seo_title: [nil, ""]).find_each do |strain|
      title = "#{strain.name} Strain#{strain.classification ? " (#{strain.classification.capitalize})" : ""} | #{shop.name}"
      desc = "Learn about the #{strain.name} cannabis strain#{strain.classification ? ", a #{strain.classification} variety," : ""} and shop #{strain.name} products at #{shop.name}."
      strain.update_columns(seo_title: title.truncate(60), seo_description: desc.truncate(155))
    end
  end

  def self.generate_blog_seo(shop)
    shop.blog_posts.where(seo_title: [nil, ""]).find_each do |post|
      title = "#{post.title} | #{shop.name}"
      desc = if post.excerpt.present?
        ActionController::Base.helpers.strip_tags(post.excerpt).squish.truncate(155)
      else
        ActionController::Base.helpers.strip_tags(post.body).squish.truncate(155)
      end
      post.update_columns(seo_title: title.truncate(60), seo_description: desc)
    end
  end

  def self.build_product_description(product, shop)
    parts = []
    parts << "Buy #{product.name}"
    parts << "by #{product.brand.name}" if product.brand
    parts << "at #{shop.name}."
    parts << "#{product.strain_classification.capitalize} strain." if product.strain_classification.present?
    if product.price_cents
      parts << "$#{'%.2f' % (product.price_cents / 100.0)}."
    end
    parts << "Order online for pickup or delivery."
    parts.join(" ").truncate(155)
  end
end
