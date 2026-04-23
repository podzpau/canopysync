class AdminUser < ApplicationRecord
  has_secure_password

  belongs_to :shop

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/, message: "is not a valid email address" }

  before_save :downcase_email

  private

  def downcase_email
    self.email = email.downcase
  end
end
