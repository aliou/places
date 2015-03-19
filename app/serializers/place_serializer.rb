# == Schema Information
#
# Table name: places
#
#  id                   :integer          not null, primary key
#  name                 :string
#  lat                  :float
#  lng                  :float
#  notes                :text
#  created_at           :datetime
#  updated_at           :datetime
#  user_id              :integer
#  foursquare_venue_id  :string
#  address              :string
#  metadata             :hstore
#  category_id          :integer
#  slug                 :string
#  foursquare_venue_url :string
#
# Indexes
#
#  index_places_on_category_id  (category_id)
#  index_places_on_slug         (slug) UNIQUE
#  index_places_on_user_id      (user_id)
#

class PlaceSerializer < ActiveModel::Serializer
  attributes :id, :slug, :name, :lat, :lng, :address, :category

  # Public: Get a simplified version of the associated category.
  #
  # Returns a Hash.
  def category
    {
      id:       object.category.id,
      name:     object.category.name,
      slug:     object.category.slug,
      icon_url: object.category.icon_url
    }
  end
end
