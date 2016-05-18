require 'test_helper'

class MealsControllerTest < ActionController::TestCase
  setup :meals_setup
  teardown :meals_teardown

  INVITES_COUNT = 'Meal.find(@meal).invited_users.count'

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
    do_login_as @user
    assert_difference('Meal.count', 1) do
      post :create, meal: attributes_for(:meal)
    end
    assert_redirected_to meal_path(assigns(:meal))
  end

  test 'should not accept invalid data' do
    do_login_as @user
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
      put :update, id: @meal, meal: attributes_for(:meal)
    end
    assert_redirected_to meal_path(assigns(:meal))
  end

  test 'should destroy meal if creator' do
    meals_setup
    do_login_as @user
    assert_difference('Meal.count', -1) do
      delete :destroy, id: @meal
    end
    assert_redirected_to meals_path
    meals_teardown
  end

  test 'should not destroy meal if not creator' do
    meals_setup
    @guest = create(:guest)
    do_login_as @guest
    assert_raise(Pundit::NotAuthorizedError) do
      delete :destroy, id: @meal
    end
    # only redirects when successful
    assert_response :success
    meals_teardown
  end

  test 'should invite unique users if creator' do
    do_login_as @user
    assert @user == @meal.user
    assert_nil @meal.invited_users.find(@user2)
    assert_difference(INVITES_COUNT, 1) do
      post :invite, meal_id: @meal, user_id: @user2
    end
  end

  test 'should not invite duplicate users if creator' do
    do_login_as @user
    assert @user == @meal.user
    @meal.invite_user @user2
    assert_not_nil @meal.invited_users.find(@user2)
    assert_no_difference(INVITES_COUNT) do
      post :invite, meal_id: @meal, user_id: @user2
    end
  end

  test 'should not invite if not meal creator' do
    @meal.user = @user2
    @meal.save
    do_login_as @user
    assert_not @user == @meal.user
    assert_nil @meal.invited_users.find(@user2)
    assert_raise(Pundit::NotAuthorizedError) do
      post :invite, meal_id: @meal, user_id: @user2
    end
  end

  test 'should uninvite users if creator' do
    do_login_as @user
    assert @user == @meal.user
    @meal.invite_user @user2
    assert_not_nil @meal.invited_users.find(@user2)
    assert_difference(INVITES_COUNT, -1) do
      delete :uninvite, meal_id: @meal, user_id: @user2
    end
  end

  test 'should not uninvite users if not creator' do
    @meal.user = @user2
    @meal.save
    do_login_as @user
    assert_not @user == @meal.user
    @meal.invite_user @user2
    assert_not_nil @meal.invited_users.find(@user2)
    assert_raise(Pundit::NotAuthorizedError) do
      delete :uninvite, meal_id: @meal, user_id: @user2
    end
  end
end
