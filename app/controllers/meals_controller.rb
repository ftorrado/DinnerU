# Controller class for showing and managing +meals+. +index+ is the
# web application +root+
class MealsController < ApplicationController
  def index
    @meals = policy_scope(Meal)
  end

  def show
    @meal = Meal.find(params[:id])
    authorize @meal
  end

  def new
    @meal = Meal.new
    authorize @meal
  end

  def edit
    @meal = Meal.find(params[:id])
    authorize @meal
  end

  def create
    @meal = Meal.new(meal_params)
    authorize @meal
    @meal.set_date params[:meal][:date] if params[:meal][:date]
    @meal.user = current_user
    if @meal.save
      redirect_to @meal
    else
      render 'new'
    end
  end

  def update
    @meal = Meal.find(params[:id])
    if @meal.update(meal_params)
      redirect_to @meal
    else
      render 'edit'
    end
  end

  def destroy
    @meal = Meal.find(params[:id])
    authorize @meal
    @meal.destroy
    redirect_to meals_path
  end

  # Invites user into meal
  def invite
    @meal = Meal.find(params[:meal_id])
    authorize @meal, :update?
    @user = if params[:user_id]
              User.find(params[:user_id])
            else
              User.find_by(name: params[:user_name])
            end
    @meal.invite_user @user
    redirect_to @meal
  end

  # Uninvites user from meal
  def uninvite
    @meal = Meal.find(params[:meal_id])
    authorize @meal, :update?
    temp_user =  @meal.invited_users.find(params[:user_id])
    @meal.invited_users.delete(temp_user)
    redirect_to @meal
  end

  private

    def meal_params
      params.require(:meal).permit(:name, :description,
                                   :location, :date)
    end
end
