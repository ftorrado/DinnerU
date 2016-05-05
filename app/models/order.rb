# Data model for orders placed on meals
class Order
  include Mongoid::Document

  belongs_to :meal

  field :dish_name, type: String
  # restaurant sensible?
  # food image
  field :info, type: String

  validates :name, presence: true, length: { minimum: 5 }
  validates :dish, presence: true, length: { minimum: 5 }
  index({ name: 1 }, { unique: true })

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
