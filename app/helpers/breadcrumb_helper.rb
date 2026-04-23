module BreadcrumbHelper
  def breadcrumb_schema(items, host:, path:)
    {
      "@context"        => "https://schema.org",
      "@type"           => "BreadcrumbList",
      "@id"             => "https://#{host}#{path}#breadcrumb",
      "itemListElement" => items.each_with_index.map do |item, i|
        { "@type" => "ListItem", "position" => i + 1, "name" => item[:name], "item" => item[:url] }
      end
    }
  end

  def breadcrumb_html(items)
    content_tag(:nav, aria: { label: "Breadcrumb" }) do
      content_tag(:ol) do
        safe_join(items.each_with_index.map do |item, i|
          content_tag(:li) do
            if i == items.length - 1
              content_tag(:span, item[:name], aria: { current: "page" })
            else
              link_to(item[:name], item[:url])
            end
          end
        end)
      end
    end
  end
end
