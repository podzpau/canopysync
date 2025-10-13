module BlockTypes
  AVAILABLE_BLOCKS = {
    'hero' => {
      name: 'Hero Section',
      fields: %w[heading subheading button_text button_url image_url]
    },
    'product_card' => {
      name: 'Product Card',
      fields: %w[heading description price image_url]
    },
    'promo_banner' => {
      name: 'Promotional',
      fields: %w[text background_color]
    },
    'new_products' => {
      name: 'New Products',
      fields: %w[heading limit]
    },
    'sales' => {
      name: 'Sales Section',
      fields: %w[heading discount_text cta_text]
    },
    'brands' => {
      name: 'Brands',
      fields: %w[heading]
    },
    'cta' => {
      name: 'Call to Action',
      fields: %w[heading text button_text button_url]
    }
  }.freeze
end