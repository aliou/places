# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  icon_url   :string(255)
#  created_at :datetime
#  updated_at :datetime
#  metadata   :hstore
#

class Category < ActiveRecord::Base

  ICON_TYPE = 'bg_64'

  ##############################################################################
  #                                                                            #
  ##############################################################################
  store_accessor :metadata, :foursquare_data

  ##############################################################################
  # Associations                                                               #
  ##############################################################################
  has_many :places

  ##############################################################################
  # Validations                                                                #
  ##############################################################################

  validates :name,     presence: true

  ##############################################################################
  # Callbacks                                                                  #
  ##############################################################################

  before_create :set_icon_url

  ##############################################################################
  # Class Methods                                                              #
  ##############################################################################

  def self.find_or_create_from_foursquare_category(cat)
    category = Category.where(name: cat['name']).first
    if category.nil?
      category = Category.create(name: cat['name'], foursquare_data: cat.to_json)
    end

    category
  end

  private

  def set_icon_url
    data = JSON.parse(self.foursquare_data)['icon']
    self.icon_url = data['prefix'] + Category::ICON_TYPE + data['suffix']
  end
end
