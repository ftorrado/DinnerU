class OrdersController < ApplicationController
  def list_names
    @orders = Order.where(name: params[:query])
    render 'list'
  end
  def list_dishes
    @orders = Order.where(dish: params[:query])
    render 'list'
  end

  def create
    @meal = Meal.find(params[:meal_id])
    if @meal.orders.where(name: :order.name).count > 0

    end
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
