# Data model class for users, these create meals, comments and
# orders. Orders are contained in orders_containers, when several
# users make one order. Also users can be invited to meals.
class User
  include Mongoid::Document
  include ActiveModel::SecurePassword

  has_many :meals
  has_and_belongs_to_many :invitations, :class_name => 'Meal',
                          :inverse_of => :invited_users

  field :name, type: String
  field :email, type: String
  field :password_digest, type: String
  field :address, type: String

  has_secure_password
  before_save { email.downcase! }

  validates :name, presence: true,
            length: { minimum: 5, maximum: 30 }
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
            length: { minimum: 5, maximum: 255 },
            format: { with: EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  index({ email: 1 }, { unique: true })


  # # Include default devise modules. Others available are:
  # # :confirmable, :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable, :validatable
  #
  # ## Database authenticatable
  # field :email,              type: String, default: ""
  # field :encrypted_password, type: String, default: ""
  #
  # ## Recoverable
  # field :reset_password_token,   type: String
  # field :reset_password_sent_at, type: Time
  #
  # ## Rememberable
  # field :remember_created_at, type: Time
  #
  # ## Trackable
  # field :sign_in_count,      type: Integer, default: 0
  # field :current_sign_in_at, type: Time
  # field :last_sign_in_at,    type: Time
  # field :current_sign_in_ip, type: String
  # field :last_sign_in_ip,    type: String
  #
  # ## Confirmable
  # # field :confirmation_token,   type: String
  # # field :confirmed_at,         type: Time
  # # field :confirmation_sent_at, type: Time
  # # field :unconfirmed_email,    type: String # Only if using reconfirmable
  #
  # ## Lockable
  # # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # # field :locked_at,       type: Time
end
