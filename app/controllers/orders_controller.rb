# Controller class for the orders
class OrdersController < ApplicationController
  def list_names
    @list = Order.list_names
    render 'list', layout: false
  end

  def list_dishes
    @list = Order.list_dishes
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
