# Data model for +meals+ scheduled using the application. This contains the
# orders done for the meal.
class Meal
  include Mongoid::Document

  has_many :orders, dependent: :destroy

  def orders_count
    orders.size
  end

  field :name, type: String
  field :location, type: String
  field :date, type: String
  # field :pass, type: String, default: ->{Random.new().rand(0x10000).to_s(16)}

  validates :name, presence: true, length: { minimum: 5 }
  index({ name: 1 }, unique: true)
end
