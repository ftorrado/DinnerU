class Meal
  include Mongoid::Document

  field :name, type: String
  field :restaurant, type: String
  field :date, type: DateTime
  field :pass, type: String, default: ->{Random.new().rand(0x10000).to_s(16)}

  validates :name, presence:true, length: {minimum: 5}
end