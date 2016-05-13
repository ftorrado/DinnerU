# Data model for +meals+ scheduled using the application. This contains the
# orders done for the meal.
class Meal
  include Mongoid::Document

  embeds_many :orders
  embeds_many :comments
  belongs_to :user, :class_name => 'User', :inverse_of => :meals
  has_and_belongs_to_many :invited_users, :class_name => 'User',
                          :inverse_of => :invitations

  field :name, type: String
  field :description, type: String
  field :location, type: String
  field :date, type: DateTime, default: DateTime.new
  field :is_visible, type: Boolean, default: false
  field :is_private, type: Boolean, default: false

  validates :user, presence: true
  validates :name, presence: true, length: { minimum: 5, maximum: 60 }
  validates :description, length: { maximum: 120 }
  validates :location, length: { maximum: 120 }

  scope :publicly_visible, lambda {
    where(is_visible: true)
  }

  scope :privately_visible_by, lambda { |user|
    where(user_id: user.id, is_visible: false)
  }

  def invite_user (user)
    invited_users << user unless invited_users.include?(user.id)
  end

  def add_order (order)
    orders << order unless orders.include?(order)
  end
end
