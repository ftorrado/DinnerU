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
  end

  test 'should get show' do
    get :show, id: @meal.id
    assert_response :success
  end

  test 'should get new' do
    get :new
    assert_response :success
    # TODO: form
  end

  test 'should get edit' do
    get :edit, id: @meal.id
    assert_response :success
    # TODO: form
  end

  test 'should redirect on create' do
    assert_difference('Meal.count') do
      post :create, {meal: build(:meal)}
    end
    assert_redirected_to meal_path(assigns(:meal))
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
