require 'test_helper'

class MealsControllerTest < ActionController::TestCase
  def setup
    @meal = create(:meal)
  end
  def teardown
    @meal.destroy
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:meals)
    assert_template ' meals/index'
  end

  test 'should get show' do
    get :show, id: @meal
    assert_response :success
    assert_not_nil assigns(:meal)
    assert_template ' meals/show'
  end

  test 'should get new' do
    get :new
    assert_response :success
    assert_not_nil assigns(:meal)
    assert_template ' meals/new'
  end

  test 'should create meal' do
    assert_difference('Meal.count', 1) do
      post :create, meal: build(:meal)
      end
    assert_redirected_to meal_path(assigns(:meal))
  end

  test 'should create meal' do
    assert_raises(Exception) do
      post :create, meal: {invalid_param: 'garbage'}
    end
  end

  test 'should get edit' do
    get :edit, id: @meal
    assert_response :success
    assert_not_nil assigns(:meal)
    assert_template ' meals/edit'
  end

  test 'should update meal' do
    assert_no_difference('Meal.count') do
      post :update, meal: @meal
    end
    assert_redirected_to meal_path(assigns(:meal))
  end

  test 'should destroy meal' do
    assert_no_difference('Meal.count', -1) do
      post :destroy, meal: @meal
    end
    assert_redirected_to meals_path
  end
end
