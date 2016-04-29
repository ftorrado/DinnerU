#
class Order
  include Mongoid::Document

  belongs_to :meal

  field :name, type: String
  field :dish, type: String
  field :comment, type: String

  validates :name, presence: true, length: { minimum: 5 }
  validates :dish, presence: true, length: { minimum: 5 }
  index({ name: 1 }, unique: true)

  def list_names
    query = /.*#{Regexp.escape(params[:query])}.*/i
    orders = Order.collection.aggregate(
      [{ '$match' => { 'name' => { '$regex' => query } } },
       { '$group' => { '_id' => { 'result' => '$name' } } }
      ])
    list = []
    orders.each do |order|
      list.push order['_id']['result']
    end
  end

  def list_dishes
    query = /.*#{Regexp.escape(params[:query])}.*/i
    orders = Order.collection.aggregate(
      [{ '$match' => { 'dish' => { '$regex' => query } } },
       { '$group' => { '_id' => { 'result' => '$dish' } } }
      ])
    list = []
    orders.each do |order|
      list.push order['_id']['result']
    end
  end
end
