# Data model for orders placed on meals
class Order
  include Mongoid::Document

  embedded_in :meal
  belongs_to :user
  embeds_many :comments

  field :description, type: String
  field :dishes, type: Array, default: []

  validates :description, presence: true, length: { maximum: 5 }

  def list_names
    orders = query_string_anywhere(params[:query], 'name')
    list = []
    orders.each do |order|
      list.push order['_id']['result']
    end
  end

  def list_dishes
    orders = query_string_anywhere(params[:query], 'dish')
    list = []
    orders.each do |order|
      list.push order['_id']['result']
    end
  end

  private

  def query_string_anywhere(value, field_name)
    query = /.*#{Regexp.escape(value)}.*/i
    Order.collection.aggregate(
      [{ '$match' => { field_name => { '$regex' => query } } },
       { '$group' => { '_id' => { 'result' => "$#{field_name}" } } }
      ])
  end
end
