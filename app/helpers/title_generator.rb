class TitleGenerator
  MAX_LENGTH = 65

  PLURALS = {
    "pre-roll"    => "Pre-Rolls",
    "vape"        => "Vapes",
    "flower"      => "Flower",
    "edible"      => "Edibles",
    "concentrate" => "Concentrates",
    "tincture"    => "Tinctures",
    "topical"     => "Topicals",
    "beverage"    => "Beverages",
    "capsule"     => "Capsules"
  }.freeze

  STRAIN_DOMINANCES = %w[Sativa Indica Hybrid sativa indica hybrid].freeze

  def self.product(product, shop: nil)
    brand_suffix = product.brand ? " | #{product.brand.name}" : ""

    base = if product.strain_name.present?
      if product.product_type == "flower"
        "#{product.strain_name} Weed Strain"
      else
        "#{product.strain_name} Weed Strain \u2013 #{format_type(product.product_type)}"
      end
    else
      product.name.to_s
    end

    with_suffix(cap("#{base}#{brand_suffix}"), shop)
  end

  def self.collection(collection, shop: nil)
    name = collection.name

    result = if collection.parent.nil?
      "Buy Cannabis #{name}"
    elsif STRAIN_DOMINANCES.include?(name)
      "Buy #{name} #{collection.parent.name}"
    else
      "Buy Cannabis #{name}"
    end

    with_suffix(cap(result), shop)
  end

  def self.brand(brand, product_type: nil, shop: nil)
    base = if product_type.nil?
      cap("Buy #{brand.name} Cannabis Products")
    else
      plural = PLURALS[product_type] || "#{product_type.split("-").map(&:capitalize).join("-")}s"
      tokens = product_type.split("-").map(&:downcase)

      if tokens.any? { |t| brand.name.downcase.include?(t) }
        cap("Buy #{brand.name} Cannabis Products")
      else
        cap("Buy #{brand.name} #{plural}")
      end
    end

    with_suffix(base, shop)
  end

  class << self
    private

    def with_suffix(title, shop)
      return title if shop.nil?
      suffix = shop.try(:default_seo_title_suffix).presence
      return title unless suffix
      "#{title}#{suffix}"
    end

    def cap(str)
      str.length > MAX_LENGTH ? str[0, MAX_LENGTH] : str
    end

    def format_type(type)
      type == "pre-roll" ? "Pre-Roll" : type.split("-").map(&:capitalize).join("-")
    end
  end
end
