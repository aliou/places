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
  store_accessor :metadata, :foursquare_data
  has_many :places

  def self.find_or_create_from_foursquare_category(cat)
    category = Category.where(name: cat['name']).first
    if category.nil?
      category = Category.create(name: cat['name'], foursquare_data: category)
    end

    category
  end
end
