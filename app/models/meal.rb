# Data model for +meals+ scheduled using the application. This contains the
# orders done for the meal.
class Meal
  include Mongoid::Document

  embeds_many :orders
  embeds_many :comments
  belongs_to :user
  has_and_belongs_to_many :invited_users, :class_name => 'User',
                          :inverse_of => :invitations

  field :name, type: String
  field :description, type: String
  field :location, type: String
  field :date, type: DateTime
  field :is_visible, type: Boolean, default: false
  field :is_private, type: Boolean, default: false

  validates :name, presence: true, length: { minimum: 5, maximum: 60 }
  validates :description, length: { maximum: 120 }
  validates :location, length: { maximum: 120 }

  scope :publicly_visible, lambda {
    where(is_visible: true)
  }

  scope :privately_visible_by, lambda { |user|
    where(user_id: user.id, is_visible: false)
  }
end
