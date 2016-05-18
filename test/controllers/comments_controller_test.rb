require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  setup :comments_setup
  teardown :comments_teardown

  test 'should create and delete comment meal' do
    do_login_as @user
    assert_difference('@meal.comments.count', 1) do
      post :create, meal_id: @meal, comment: {text: 'this comment'}
    end
    assert_redirected_to meal_path(assigns(:meal))
  end

  test 'should create and delete comment order' do
    do_login_as @user
    assert_difference('@order.comments.count', 1) do
      post :create, meal_id: @meal, order_id: @order,
           comment: {text: 'new comment'}
    end
    assert_redirected_to meal_path(assigns(:meal))
  end

  test 'should block comment without permission' do
    @user2 = create(:user)
    @private_meal = create(:private_meal, user: @user2)
    do_login_as @user
    assert_raise(Pundit::NotAuthorizedError) do
      post :create, meal_id: @private_meal, comment: {text: 'new'}
    end
    assert_redirected_to meal_path(assigns(:meal))
    @private_meal.destroy
    @user2.destroy
  end

  test 'should destroy own comment' do
    do_login_as @user
    assert_difference('@meal.comments.count', -1) do
      delete :destroy, meal_id: @meal, id: @comment
    end
    assert_redirected_to meal_path(assigns(:meal))
  end

  test 'should block delete comment without permission' do
    @user2 = create(:user)
    do_login_as @user2
    assert_no_difference('@meal.comments.count') do
      delete :destroy, meal_id: @meal, id: @comment
    end
    assert_redirected_to meal_path(assigns(:meal))
    @user2.destroy
  end
end
