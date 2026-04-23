module SeoMetaHelper
  def seo_for_product(product)
    shop = Current.shop
    path = "/product/#{product.slug}/"
    canonical = product.seo_canonical_url.presence || "https://#{shop.domain}#{path}"

    title = product.seo_title.presence || TitleGenerator.product(product, shop: shop)
    desc  = product.seo_description.presence ||
            seo_description(product.description, shop: shop)

    content_for(:title) { title }
    set_seo_meta(description: desc, canonical: canonical,
                 robots: product.seo_robots.presence)

    product_schemas(product, shop: shop).each { |s| append_schema(s) }
    append_schema(shop_org_schema(shop))

    crumbs = product_crumbs(product, shop: shop)
    append_schema(breadcrumb_schema(crumbs, host: shop.domain, path: path))
    content_for(:breadcrumb) { breadcrumb_html(crumbs) }

    nil
  end

  def seo_for_collection(collection, products: [])
    shop = Current.shop
    path = seo_collection_path(collection)
    canonical = collection.seo_canonical_url.presence || "https://#{shop.domain}#{path}"

    title = collection.seo_title.presence || TitleGenerator.collection(collection, shop: shop)
    desc  = collection.seo_description.presence ||
            seo_description(collection.description, shop: shop)

    content_for(:title) { title }
    set_seo_meta(description: desc, canonical: canonical,
                 robots: collection.seo_robots.presence)

    collection_schemas(collection, products: products, shop: shop).each { |s| append_schema(s) }
    append_schema(shop_org_schema(shop))

    crumbs = collection_crumbs(collection, shop: shop)
    append_schema(breadcrumb_schema(crumbs, host: shop.domain, path: path))
    content_for(:breadcrumb) { breadcrumb_html(crumbs) }

    nil
  end

  def seo_for_brand(brand, products: [], product_type: nil)
    shop = Current.shop
    path = "/brand/#{brand.slug}/"
    canonical = brand.seo_canonical_url.presence || "https://#{shop.domain}#{path}"

    title = brand.seo_title.presence || TitleGenerator.brand(brand, product_type: product_type, shop: shop)
    desc  = brand.seo_description.presence ||
            seo_description(brand.description, shop: shop)

    content_for(:title) { title }
    set_seo_meta(description: desc, canonical: canonical,
                 robots: brand.seo_robots.presence)

    brand_schemas(brand, products: products, shop: shop).each { |s| append_schema(s) }
    append_schema(shop_org_schema(shop))

    crumbs = brand_crumbs(brand, shop: shop)
    append_schema(breadcrumb_schema(crumbs, host: shop.domain, path: path))
    content_for(:breadcrumb) { breadcrumb_html(crumbs) }

    nil
  end

  private

  def set_seo_meta(description:, canonical:, robots: nil)
    content_for(:meta) do
      tag.meta(name: "description", content: description)
    end
    content_for(:robots) do
      tag.meta(name: "robots", content: robots || "index, follow")
    end
    effective_canonical = @noindex_canonical || canonical
    content_for(:canonical) { tag.link(rel: "canonical", href: effective_canonical) }
  end

  def append_schema(schema)
    content_for(:schema) do
      content_tag(:script, json_escape(schema.to_json).html_safe, type: "application/ld+json")
    end
  end

  def seo_description(text, max: 155, shop: nil)
    return text.to_s.truncate(max) if text.present?
    shop ||= Current.shop
    shop.default_meta_description.presence&.truncate(max) || ""
  end

  def product_crumbs(product, shop:)
    [
      { name: "Home", url: "https://#{shop.domain}/" },
      { name: product.name, url: "https://#{shop.domain}/product/#{product.slug}/" }
    ]
  end

  def collection_crumbs(collection, shop:)
    items = [ { name: "Home", url: "https://#{shop.domain}/" } ]
    if collection.parent
      items << { name: collection.parent.name, url: "https://#{shop.domain}/collection/#{collection.parent.slug}/" }
    end
    items << { name: collection.name, url: "https://#{shop.domain}#{seo_collection_path(collection)}" }
    items
  end

  def brand_crumbs(brand, shop:)
    [
      { name: "Home",   url: "https://#{shop.domain}/" },
      { name: "Brands", url: "https://#{shop.domain}/brands/" },
      { name: brand.name, url: "https://#{shop.domain}/brand/#{brand.slug}/" }
    ]
  end
end
