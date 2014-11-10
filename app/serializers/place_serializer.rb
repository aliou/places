class PlaceSerializer < ActiveModel::Serializer
  attributes :name, :lat, :lng, :address, :category
end
