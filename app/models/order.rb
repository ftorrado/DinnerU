# Data model for orders placed on meals
class Order
  include Mongoid::Document

  embedded_in :meal
  belongs_to :user
  embeds_many :comments
  # No inverse to only have references on this side
  has_and_belongs_to_many :dishes, inverse_of: nil

  field :description, type: String

  validates :user, presence: true
  validates :description, length: { maximum: 60 }
end
