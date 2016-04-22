class Meal
  include Mongoid::Document

  has_many :orders, dependent: :destroy

  def ordersCount
    return self.orders.where(meal_id: self.id).count
  end

  field :name, type: String
  field :location, type: String
  field :date, type: String
  #field :pass, type: String, default: ->{Random.new().rand(0x10000).to_s(16)}

  validates :name, presence:true, length: {minimum: 5}
  index({ name: 1 }, { unique: true })
end