class Place < ActiveRecord::Base
  acts_as_mappable :default_units => :kms

  validates :name, presence: true
  validates :lat , presence: true
  validates :lng , presence: true
end
