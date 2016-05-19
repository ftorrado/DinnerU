# Controller for the dishes
class DishesController < ApplicationController
  # Filters with Pundit policy and by search query, if any
  def index
    @dishes = policy_scope(Dish).search_by(params[:search])
    respond_to do |format|
      format.html
      format.json { render json: @dishes.as_json }
    end
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
    @dish = Dish.find(params[:id])
    authorize @dish
    @dish.destroy
    redirect_to dishes_path
  end

  private

    def dish_params
      params.require(:dish).permit(:name, :info)
    end
end
