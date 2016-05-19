# Comments controller, only deals with creating and deleting
class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @meal = Meal.find(params[:meal_id])
    authorize @meal, :participate?
    if params[:order_id]
      # inside order
      @order = @meal.orders.find(params[:order_id])
      @order.comments << @comment
    else
      # inside meal
      @meal.comments << @comment
    end
    @meal.save
    redirect_to @meal
  end

  def destroy
    @meal = Meal.find(params[:meal_id])
    if params[:order_id]
      # inside order
      @order = @meal.orders.find(params[:order_id])
      authorize @order, :update?
      @comment = @order.comments.find(params[:id])
      @order.comments.delete(@comment) if @comment.user == current_user
    else
      # inside meal
      authorize @meal, :participate?
      @comment = @meal.comments.find(params[:id])
      @meal.comments.delete(@comment) if @comment.user == current_user
    end
    redirect_to @meal
  end

  private

    def comment_params
      params.permit(:text)
    end
end
