class PlaceSerializer < ActiveModel::Serializer
  attributes :id, :name, :lat, :lng, :address, :category

  def category
    {
      name:      object.category.name,
      icon_url:  object.category.icon_url
    }
  end
end
