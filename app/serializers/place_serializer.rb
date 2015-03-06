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
