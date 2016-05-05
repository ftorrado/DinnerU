require 'test_helper'

class MealsControllerTest < ActionController::TestCase
  def setup
    @meal = Meal.new(name: 'The last supper',
                     location: 'Stairway to heaven',
                     orders_users_count: 12,
                     visible: true, private: false)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:meals)
  end

  test 'should get show' do
    get :show, meal_id: @meal.id
    assert_response :success
  end

  test 'should get new' do
    get :new
    assert_response :success
    # TODO: form
  end

  test 'should get edit' do
    get :edit, meal_id: @meal.id
    assert_response :success
    # TODO: form
  end

  test 'should redirect on create' do
    assert_difference('Meal.count') do
      post :create, meal: {}
      # TODO: new obj
    end
    assert_redirected_to article_path(assigns(:meal))
  end

  test 'should show error on create existing' do
    assert_no_difference('Meal.count') do
      post :create, meal: {}
      # TODO: existing obj
    end
    assert_response :success
  end

  test 'should update meal' do
    assert true
    # TODO: existing obj
    # post :update, meal: {}
  end

  test 'should destroy meal' do
    assert true
    # TODO: existing obj
    # post :destroy, meal: {}
  end
end
