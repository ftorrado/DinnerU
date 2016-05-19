require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  setup :comments_setup
  teardown :comments_teardown

  ORDER_COMMENTS_COUNT = 'Meal.find(@meal).orders.find(@order).comments.count'
  MEAL_COMMENTS_COUNT = 'Meal.find(@meal).comments.count'

  test 'should create comment on meal' do
    do_login_as @user
    assert_difference(MEAL_COMMENTS_COUNT, 1) do
      post :create, meal_id: @meal, comment: {text: 'this comment'}
    end
    assert_redirected_to meal_path(assigns(:meal))
  end

  test 'should create and delete comment on order' do
    do_login_as @user
    assert_difference(ORDER_COMMENTS_COUNT, 1) do
      post :create, meal_id: @meal, order_id: @order,
           text: 'new comment'
    end
    assert_redirected_to meal_path(assigns(:meal))
  end

  test 'should not create comment without permission' do
    @user2 = create(:user)
    @private_meal = create(:private_meal, user: @user2)
    do_login_as @user
    assert_raise(Pundit::NotAuthorizedError) do
      post :create, meal_id: @private_meal, comment: {text: 'new'}
    end
    @private_meal.destroy
    @user2.destroy
  end

  test 'should destroy own comment' do
    do_login_as @user
    assert_difference(MEAL_COMMENTS_COUNT, -1) do
      delete :destroy, meal_id: @meal, id: @comment
    end
    assert_redirected_to meal_path(assigns(:meal))
  end

  test 'should block delete comment without permission' do
    @user2 = create(:user)
    do_login_as @user2
    assert_no_difference(MEAL_COMMENTS_COUNT) do
      delete :destroy, meal_id: @meal, id: @comment
    end
    @user2.destroy
  end
end
