# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  icon_url   :string
#  created_at :datetime
#  updated_at :datetime
#  metadata   :hstore
#  slug       :string
#
# Indexes
#
#  index_categories_on_slug  (slug) UNIQUE
#

class Category < ActiveRecord::Base
  extend FriendlyId

  ICON_TYPE = 'bg_64'

  store_accessor :metadata, :foursquare_data

  has_many :places

  validates :name, presence: true

  before_create :set_icon_url

  friendly_id :name, use: [:slugged, :finders]

  # Public: Finds or creates a new Category from a Foursquare category.
  #
  # category - The Foursquare category.
  #
  # Returns a Category or nil.
  def self.from_foursquare(category)
    Category.where(name: category['name']).first ||
      Category.create_from_foursquare(category)
  end

  # Public: Creates a new Category from a Foursquare category.
  #
  # category - The Foursquare category.
  #
  # Returns a Category or nil.
  def self.create_from_foursquare(category)
    Category.create!(name: category['name'], foursquare_data: category.to_json)
  rescue ActiveRecord::RecordInvalid
    return nil
  end

  private

  def set_icon_url
    data = JSON.parse(self.foursquare_data)['icon']
    self.icon_url = data['prefix'] + Category::ICON_TYPE + data['suffix']
  end
end
