module InternalLinkHelper
  def auto_link_content(html)
    return html if html.blank?
    return html unless Current.shop

    InternalLinker.call(html, shop: Current.shop).html_safe
  end
end
