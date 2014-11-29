class PlaceSerializer < ActiveModel::Serializer
  attributes :name, :lat, :lng, :address, :category

  def category
    {
      name:      object.category.name,
      icon_url:  object.category.icon_url
    }
  end
end
