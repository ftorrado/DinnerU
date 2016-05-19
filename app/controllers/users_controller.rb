# Controller for creating, showing and managing users
class UsersController < ApplicationController
  def index
    @users = User.all.search_by(params[:search])
    respond_to do |format|
      format.html
      format.json { render json: @users.as_json }
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.is_guest = false
    if @user.save
      log_in @user
      flash[:success] = 'Welcome to DinnerU!'
      redirect_to @user
    else
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
