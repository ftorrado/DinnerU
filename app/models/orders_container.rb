class OrdersContainer
  include Mongoid::Document

  embedded_in :meal
  has_many :orders
  references_many :users
  embeds_many :comments

  field :description, type: String

  def users
    User.where(:'_id'.in => self.user_ids).all.map(&:user)
  end
end
