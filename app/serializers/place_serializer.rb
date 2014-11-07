class PlaceSerializer < ActiveModel::Serializer
  attributes :name, :lat, :lng
end
