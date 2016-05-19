class Dish
  include Mongoid::Document

  field :name, type: String
  # restaurant sensible?
  # food image
  field :info, type: String

  validates :name, presence: true, length: { minimum: 5, maximum: 60 }
  index({ name: 1 }, { unique: true })

  scope :search_by, lambda { |search|
    if search
      regex_query = /.*#{Regexp.escape(search)}.*/i
      where('name': { '$regex': regex_query })
    end
  }
end
