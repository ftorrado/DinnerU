class OrdersController < ApplicationController
  def list_names
    @query = /.*#{Regexp.escape(params[:query])}.*/i
    stages = [
        {"$match"=> {"name" => {"$regex" => @query}}},
        {"$group"=> { "_id" => {"result" => "$name"}}}
    ]
    @orders = Order.collection.aggregate(stages)
    @list = Array.new
    @orders.each do |order|
      @list.push order['_id']['result']
    end
    render 'list', layout: false
  end
  def list_dishes
    @query = /.*#{Regexp.escape(params[:query])}.*/i
    stages = [
        {"$match"=> {"dish" => {"$regex" => @query}}},
        {"$group"=> { "_id" => {"result" => "$dish"}}}
    ]
    @orders = Order.collection.aggregate(stages)
    @list = Array.new
    @orders.each do |order|
      @list.push order['_id']['result']
    end
    render 'list', layout: false
  end

  def create
    @meal = Meal.find(params[:meal_id])
    @order = @meal.orders.create(order_params)
    redirect_to meal_path(@meal)
  end

  def destroy
    @meal = Meal.find(params[:meal_id])
    @order = @meal.orders.find(params[:id])
    @order.destroy
    redirect_to meal_path(@meal)
  end

  private
  def order_params
    params.require(:order).permit(:name, :dish, :comment)
  end
end
