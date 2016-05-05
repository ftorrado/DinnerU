class Comment
  include Mongoid::Document

  belongs_to :user
  embedded_in :meal
  embedded_in :orders_container

  field :content, type: String
  validates :content, presence: true, length: { minimum: 2,
                                                maximum: 60 }
end
