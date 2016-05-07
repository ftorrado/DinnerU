class Comment
  include Mongoid::Document

  belongs_to :user
  embedded_in :meal
  embedded_in :order

  field :text, type: String
  validates :text, presence: true, length: { minimum: 2, maximum: 60 }
end
