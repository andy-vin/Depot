class Product < ActiveRecord::Base
  has_many :line_items
  has_many :orders, through: :line_items

  before_destroy :ensure_not_referenced_by_any_line_item
  # Validation block
  # Begin

  # not empty fields title, description, image url
  validates :title, :description, :image_url, presence: true

  # price more then 0.00 for price
  validates :price, numericality: {
            greater_than_or_equal_to: 0.01
  }

  # unique names for title
  validates :title, uniqueness: true

  # end of link should be image
  validates :image_url, allow_blank: true, format: {
            with: %r{\.(gif|jpg|png)\Z}i,
            message: 'URL должен указывать на изображение формата GIF, JPG или PNG'
  }

  # title must include 10 and more characters
  validates :title, length: {
                      minimum: 10,
                      too_short: "must have at least %{count} characters"
                  }
  # last update in product list
  def self.latest
    Product.order(:updated_at).last
  end
  # end

  private
  # убеждаемся в отсутствии товарных позиций, ссылающихся на данный товар
  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, 'существуют товарные позиции')
      return false
    end
  end
end
