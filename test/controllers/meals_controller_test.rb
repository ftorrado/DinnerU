require 'test_helper'

class MealsControllerTest < ActionController::TestCase
  setup :meals_setup
  teardown :meals_teardown

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:meals)
    assert_template 'meals/index'
  end

  test 'should get show' do
    get :show, id: @meal
    assert_response :success
    assert_not_nil assigns(:meal)
    assert_template 'meals/show'
  end

  test 'should get new' do
    get :new
    assert_response :success
    assert_not_nil assigns(:meal)
    assert_template 'meals/new'
  end

  test 'should create meal' do
    do_log_in @user
    assert_difference('Meal.count', 1) do
      post :create, meal: attributes_for(:meal)
    end
    assert_redirected_to meal_path(assigns(:meal))
  end

  test 'should not accept invalid data' do
    do_log_in @user
    assert_no_difference('Meal.count') do
      post :create, meal: {invalid_param: 'garbage'}
    end
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @meal
    assert_response :success
    assert_not_nil assigns(:meal)
    assert_template 'meals/edit'
  end

  test 'should update meal' do
    assert_no_difference('Meal.count') do
      post :update, id: @meal, meal: attributes_for(:meal)
    end
    assert_redirected_to meal_path(assigns(:meal))
  end

  test 'should destroy meal if creator' do
    meals_setup
    do_log_in @user
    assert_difference('Meal.count', -1) do
      post :destroy, id: @meal
    end
    assert_redirected_to meals_path
    meals_teardown
  end

  test 'should not destroy meal if not creator' do
    meals_setup
    @guest = create(:guest)
    do_log_in @guest
    assert_raise(Pundit::NotAuthorizedError) do
      post :destroy, id: @meal
    end
    # only redirects when successful
    assert_response :success
    meals_teardown
  end

  test 'should invite other users without duplicates if creator' do
    do_log_in @user
    josh = create(:josh)
    assert_difference('@meal.invited_users.count', 1) do
      post :invite, id: @meal, invite: { id: josh.id }
    end
    josh.destroy
  end

  test 'should not invite if not meal creator' do
    josh = create(:josh)
    do_log_in josh
    assert_no_difference('@meal.invited_users.count') do
      post :invite, id: @meal, invite: { id: @user.id }
    end
    josh.destroy
  end
end
