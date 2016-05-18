# Controller class for the orders embedded inside meals
class OrdersController < ApplicationController
  def show
    @meal = Meal.find(params[:meal_id])
    @order = @meal.orders.find(params[:id])
    authorize @order
  end

  def new
    @meal = Meal.find(params[:meal_id])
    @order = Order.new
    @order.meal = @meal
    permission = OrderPolicy.new(current_user, @order).new?
    if !permission
      # rollback
      @meal.delete(@order)
      raise Pundit::NotAuthorizedError
    end
  end

  def create
    @meal = Meal.find(params[:meal_id])
    @order = Order.new(order_params)
    @order.meal = @meal
    permission = OrderPolicy.new(current_user, @order).create?
    if !permission
      # rollback
      @meal.delete(@order)
      raise Pundit::NotAuthorizedError
    else
      @order.user = current_user
      @meal.orders << @order
      if !@meal.save
        flash[:danger] = 'Error storing data'
      end
      redirect_to [@meal, @order]
    end
  end

  def edit
    @meal = Meal.find(params[:meal_id])
    @order = @meal.orders.find(params[:id])
    authorize @order
  end

  def update
    @meal = Meal.find(params[:meal_id])
    @order = @meal.orders.find(params[:id])
    authorize @order
    if !@order.update(order_params)
      flash[:danger] = 'Error storing data'
    end
    redirect_to [@meal, @order]
  end

  def destroy
    @meal = Meal.find(params[:meal_id])
    @order = @meal.orders.find(params[:id])
    authorize @order
    @meal.orders.delete(@order)
    redirect_to @meal
  end


  # Called to add a dish to a meal order
  def add_dish
    @meal = Meal.find(params[:meal_id])
    @order = @meal.orders.find(params[:order_id])
    authorize @order, :update?
    @dish = Dish.find(params[:dish_id])
    @order.dishes << @dish
    @order.save
    redirect_to [@meal, @order]
  end

  # Called to remove a dish from a meal order
  def remove_dish
    @meal = Meal.find(params[:meal_id])
    @order = @meal.orders.find(params[:order_id])
    authorize @order, :update?
    @dish = @order.dishes.find(params[:dish_id])
    @order.dishes.delete(@dish) if @dish
    @order.save
    redirect_to [@meal, @order]
  end

  private

    def order_params
      params.require(:order).permit(:description)
    end
end
