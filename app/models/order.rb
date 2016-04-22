class Order
  include Mongoid::Document

  belongs_to :meal

  field :name, type: String
  field :dish, type: String
  field :comment, type: String

  validates :name, presence:true, length: {minimum: 5}
  validates :dish, presence:true, length: {minimum: 5}
  index({ name: 1 }, { unique: true })
end
