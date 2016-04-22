class OrdersController < ApplicationController
  def list_names
    @orders = Order.where(name: params[:query])
    @list = Array.new
    @orders.each do |order|
      @list.push order.name
    end
    render 'list', layout: false
  end
  def list_dishes
    @orders = Order.where(dish: params[:query])
    @list = Array.new
    @orders.each do |order|
      @list.push order.dish
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
