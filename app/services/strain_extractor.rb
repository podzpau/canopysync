class StrainExtractor
  def self.call(shop)
    products = shop.products.where.not(strain_classification: nil)

    products.select(:name, :strain_classification).distinct.each do |product|
      strain_name = extract_strain_name(product)
      next if strain_name.blank?

      shop.strains.find_or_create_by!(name: strain_name) do |s|
        s.slug = strain_name.parameterize
        s.classification = product.strain_classification
      end
    end
  end

  def self.extract_strain_name(product)
    name = product.name.to_s.strip
    name = name.split(" - ").last if name.include?(" - ")
    name = name.split(" | ").last if name.include?(" | ")
    name.strip.presence
  end
end
