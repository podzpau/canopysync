module SeoScorable
  extend ActiveSupport::Concern

  included do
    before_save :calculate_seo_score
  end

  private

  def calculate_seo_score
    score = 0

    # Custom title (+15), and length in sweet spot (+10)
    if seo_title.present?
      score += 15
      score += 10 if seo_title.length.between?(50, 60)
    end

    # Custom description (+15), and length in sweet spot (+10)
    if seo_description.present?
      score += 15
      score += 10 if seo_description.length.between?(120, 155)
    end

    # Has focus keyword (+10)
    if seo_focus_keyword.present?
      score += 10
      kw = seo_focus_keyword.downcase

      # Keyword in title (+10)
      score += 10 if seo_title.present? && seo_title.downcase.include?(kw)

      # Keyword in description (+10)
      score += 10 if seo_description.present? && seo_description.downcase.include?(kw)
    end

    # Has an image (+10)
    score += 10 if seo_has_image?

    # Has description/content (+10)
    score += 10 if respond_to?(:description) && description.present?

    self.seo_score = score
  end

  # Override in each model
  def seo_has_image?
    false
  end
end
