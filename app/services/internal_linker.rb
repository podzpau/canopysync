class InternalLinker
  # Takes a block of HTML/text content and a shop, returns the content
  # with brand names, collection names, and strain names auto-linked
  # to their corresponding storefront pages.
  #
  # Rules:
  # - Only link the FIRST occurrence of each term per content block
  # - Don't link inside existing <a> tags
  # - Don't link inside headings (h1-h6)
  # - Case-insensitive matching, but preserve original casing in output
  # - Skip terms shorter than 3 characters

  def self.call(html, shop:, max_links: 10)
    return html if html.blank?

    doc = Nokogiri::HTML::DocumentFragment.parse(html)
    linked_count = 0
    linked_terms = Set.new

    link_map = build_link_map(shop)
    # Sort by length descending so "Blue Dream Pre-Roll" matches before "Blue Dream"
    sorted_terms = link_map.keys.sort_by { |t| -t.length }

    doc.traverse do |node|
      next unless node.text?
      next if linked_count >= max_links
      next if inside_link_or_heading?(node)

      text = node.content
      replaced = false

      sorted_terms.each do |term|
        next if linked_count >= max_links
        next if linked_terms.include?(term.downcase)

        pattern = /\b(#{Regexp.escape(term)})\b/i
        if text.match?(pattern)
          text = text.sub(pattern) do |match|
            linked_count += 1
            linked_terms.add(term.downcase)
            "<a href=\"#{link_map[term]}\" class=\"internal-link\">#{match}</a>"
          end
          replaced = true
        end
      end

      if replaced
        node.replace(Nokogiri::HTML::DocumentFragment.parse(text))
      end
    end

    doc.to_html
  end

  def self.build_link_map(shop)
    map = {}

    shop.brands.each do |brand|
      map[brand.name] = "/brand/#{brand.slug}/" if brand.name.length >= 3
    end

    shop.collections.where(published: true).each do |collection|
      path = collection.parent ? "/collection/#{collection.parent.slug}/#{collection.slug}/" : "/collection/#{collection.slug}/"
      map[collection.name] = path if collection.name.length >= 3
    end

    if shop.respond_to?(:strains)
      shop.strains.each do |strain|
        map[strain.name] = "/strains/#{strain.slug}/" if strain.name.length >= 3
      end
    end

    map
  end

  private_class_method

  def self.inside_link_or_heading?(node)
    current = node.parent
    while current
      return true if current.name == "a"
      return true if current.name.match?(/\Ah[1-6]\z/)
      current = current.parent
    end
    false
  end
end
