class OrdersContainer
  include Mongoid::Document

  embedded_in :meal
  has_many :orders
  belongs_to :user

  field :description, type: String
end
