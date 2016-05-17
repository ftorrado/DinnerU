# Controller for the dishes, including actions to manage dishes
# inside orders.
class DishesController < ApplicationController
  # Filters with Pundit policy and by search query, if any
  def index
    @dishes = policy_scope(Dish).search_by(params[:search])
  end

  def show
    @dish = Dish.find(params[:id])
    authorize @dish
  end

  def new
    @dish = Dish.new
    authorize @dish
  end

  def edit
    @dish = Dish.find(params[:id])
    authorize @dish
  end

  def create
    # when doing post inside an order
    return add_to_order unless params[:order_id].nil?

    # regular form post request
    @dish = Dish.new(dish_params)
    authorize @dish
    if @dish.save
      redirect_to @dish
    else
      render 'new'
    end
  end

  def update
    @dish = Dish.find(params[:id])
    authorize @dish
    if @dish.update(dish_params)
      redirect_to @dish
    else
      render 'edit'
    end
  end

  def destroy
    # when removing from inside an order
    return remove_from_order unless params[:order_id].nil?

    @dish = Dish.find(params[:id])
    authorize @dish
    @dish.destroy
    redirect_to dishes_path
  end

  private

    def dish_params
      params.require(:dish).permit(:name, :info)
    end

    # Called to add a dish to a meal order
    def add_to_order
      meal = Meal.find(params[:meal_id])
      order = meal.orders.find(params[:order_id])
      dish = Dish.find(params[:id])
      order.dishes << dish
      redirect_to meal
    end

    # Called to remove a dish from a meal order
    def remove_from_order
      meal = Meal.find(params[:meal_id])
      order = meal.orders.find(params[:order_id])
      order.dishes.delete(params[:id])
      redirect_to meal
    end
end
