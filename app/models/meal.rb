# Data model for +meals+ scheduled using the application. This contains the
# orders done for the meal.
class Meal
  include Mongoid::Document

  embeds_many :orders_containers
  has_many :comments
  belongs_to :user

  field :name, type: String
  field :description, type: String
  field :location, type: String
  field :date, type: DateTime
  field :orders_users_count, type: Integer, default: 0
  field :visible, type: Boolean, default: false
  field :private, type: Boolean, default: false

  validates :name, presence: true, length: { minimum: 5 }
  index({ name: 1 }, {unique: true})


  scope :publicly_visible, lambda {
    where(visible: true)
  }

  scope :privately_visible_by, lambda { |user|
    where(user_id: user.id, visible: false)
  }
end
