class Dish
  include Mongoid::Document

  field :name, type: String
  # restaurant sensible?
  # food image
  field :info, type: String

  validates :name, presence: true, length: { minimum: 5, maximum: 60 }
  index({ name: 1 }, { unique: true })
  index(name: 'text')

  scope :search_by, lambda { |search|
    where('$text': { '$search': search }) if search
  }
end
