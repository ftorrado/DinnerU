# Controller class for the orders embedded inside meals
class OrdersController < ApplicationController
  def show
    @meal = Meal.find(params[:meal_id])
    @order = @meal.orders.find(params[:id])
    render '_order'
  end

  def new
    @meal = Meal.find(params[:meal_id])
    @order = Order.new
    render '_form'
  end

  def create
    @meal = Meal.find(params[:meal_id])
    temp_user = current_or_guest_user
    # @meal.orders.where(user: temp_user)
    @order = Order.new(order_params)
    @order.user = temp_user
    @meal.orders << @order
    if !@meal.save
      flash[:danger] = 'Error storing data'
    end
    redirect_to meal_path(@meal)
  end

  def edit
    @meal = Meal.find(params[:meal_id])
    @order = @meal.orders.find(params[:id])
    render '_form'
  end

  def update
    @meal = Meal.find(params[:meal_id])
    @order = @meal.orders.find(params[:id])
    if !@order.update(order_params)
      flash[:danger] = 'Error storing data'
    end
    redirect_to meal_path(@meal)
  end

  def destroy
    @meal = Meal.find(params[:meal_id])
    @order = @meal.orders.find(params[:id])
    @meal.delete(@order)
    redirect_to meal_path(@meal)
  end

  private

    def order_params
      params.require(:order).permit(:description)
    end
end
