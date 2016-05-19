# Data model class for users, these create meals, comments and
# orders. Orders are contained in orders_containers, when several
# users make one order. Also users can be invited to meals.
class User
  include Mongoid::Document
  include ActiveModel::SecurePassword

  attr_accessor :remember_token

  has_many :meals, :class_name => 'Meal', :inverse_of => :user
  has_and_belongs_to_many :invitations, :class_name => 'Meal',
                          :inverse_of => :invited_users

  field :name, type: String
  field :email, type: String
  field :password_digest, type: String
  field :remember_digest, type: String
  field :address, type: String
  field :is_guest, type: Boolean, default: true

  has_secure_password
  before_save { email.downcase! unless email.nil? }

  validates :name, presence: true,
            length: { minimum: 5, maximum: 30 }
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
            length: { minimum: 5, maximum: 255 },
            format: { with: EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  index({ email: 1 }, { unique: true })
  index({ name: 1 }, { unique: true })

  scope :search_by, lambda { |search|
    if search
      regex_query = /.*#{Regexp.escape(search)}.*/i
      where('name': { '$regex': regex_query })
    end
  }

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a new random token
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end
end
