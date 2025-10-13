class Shop < ApplicationRecord
  include BlockTypes
  
  serialize :blocks_config, coder: JSON
  enum :template, { modern: 0, classic: 1, minimal: 2 }
  attribute :corner_style, :string, default: 'rounded'

  
  # Font library - curated for cannabis/retail brands
  FONT_LIBRARY = {
    'Inter' => { 
      name: 'Inter', 
      url: 'https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap', 
      vibe: 'Modern, Clean' 
    },
    'Poppins' => { 
      name: 'Poppins', 
      url: 'https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap', 
      vibe: 'Friendly, Rounded' 
    },
    'Montserrat' => { 
      name: 'Montserrat', 
      url: 'https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&display=swap', 
      vibe: 'Bold, Urban' 
    },
    'Lora' => { 
      name: 'Lora', 
      url: 'https://fonts.googleapis.com/css2?family=Lora:wght@400;600;700&display=swap', 
      vibe: 'Elegant, Serif' 
    },
    'Space Grotesk' => { 
      name: 'Space Grotesk', 
      url: 'https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;600;700&display=swap', 
      vibe: 'Tech, Futuristic' 
    },
    'Syne' => { 
      name: 'Syne', 
      url: 'https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700&display=swap', 
      vibe: 'Unique, Editorial' 
    }
  }.freeze
  
  def blocks
    blocks_config.is_a?(Array) ? blocks_config : []
  end
  
  def blocks=(value)
    self.blocks_config = value
  end
  
  def add_block(type, config = {})
    current_blocks = blocks.dup # Get a copy of current blocks
    current_blocks << { 'type' => type, 'config' => config, 'id' => SecureRandom.hex(4) }
    self.blocks_config = current_blocks # Save it back
    save
  end
  
  # Generate accessible color variants from primary/secondary
  def theme_colors
    {
      primary: primary_color,
      primary_dark: darken_color(primary_color, 0.15),
      primary_light: lighten_color(primary_color, 0.9),
      secondary: secondary_color,
      secondary_dark: darken_color(secondary_color, 0.15),
      secondary_light: lighten_color(secondary_color, 0.9),
      text_on_primary: text_color_for(primary_color),
      text_on_secondary: text_color_for(secondary_color)
    }
  end
  
  def font_url
    custom_font_url.presence || FONT_LIBRARY.dig(font_family, :url)
  end
  
  private
  
  # Simple color manipulation - keeps it in Ruby, no JS needed
  def darken_color(hex, amount)
    hex = hex.delete('#')
    rgb = hex.scan(/../).map { |c| c.hex }
    rgb = rgb.map { |c| [(c * (1 - amount)).round, 0].max }
    '#' + rgb.map { |c| c.to_s(16).rjust(2, '0') }.join
  end
  
  def lighten_color(hex, amount)
    hex = hex.delete('#')
    rgb = hex.scan(/../).map { |c| c.hex }
    rgb = rgb.map { |c| [c + ((255 - c) * amount).round, 255].min }
    '#' + rgb.map { |c| c.to_s(16).rjust(2, '0') }.join
  end
  
  # Calculate contrast ratio and return white or black text
  def text_color_for(bg_hex)
    hex = bg_hex.delete('#')
    rgb = hex.scan(/../).map { |c| c.hex }
    
    # Calculate relative luminance
    luminance = (0.299 * rgb[0] + 0.587 * rgb[1] + 0.114 * rgb[2]) / 255
    
    luminance > 0.5 ? '#000000' : '#ffffff'
  end
end