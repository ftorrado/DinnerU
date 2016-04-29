require 'test_helper'

class MealsControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:meals)
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
    # TODO - form
  end

  test "should get edit" do
    get :edit
    assert_response :success
    # TODO - form
  end

  test "should redirect on create" do
    assert_difference('Meal.count') do
      post :create, meal: {}
      # TODO - new obj
    end
    assert_redirected_to article_path(assigns(:meal))
  end

  test "should show error on create existing" do
    assert_no_difference('Meal.count') do
      post :create, meal: {}
      # TODO - existing obj
    end
    assert_response :success
  end

  test "should update meal" do
    assert true
    # TODO - existing obj
    # post :update, meal: {}
  end

  test "should destroy meal" do
    assert true
    # TODO - existing obj
    # post :destroy, meal: {}
  end

end
