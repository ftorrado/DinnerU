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
    authorize @meal, :participate?
    if params[:order_id]
      # inside order
      @order = @meal.orders.find(params[:order_id])
      @comment = @order.comments.find(params[:id])
      if @comment.user == current_user
        @order.comments.delete(@comment)
      end
    else
      # inside meal
      @comment = @meal.comments.find(params[:id])
      if @comment.user == current_user
        @meal.comments.delete(@comment)
      end
    end
    redirect_to @meal
  end

  private

    def comment_params
      params.require(:comment).permit(:text)
    end
end
