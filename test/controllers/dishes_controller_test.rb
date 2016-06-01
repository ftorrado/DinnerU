require 'test_helper'

class DishesControllerTest < ActionController::TestCase
  setup :dishes_setup
  teardown :dishes_teardown

  check_navigation_section do
    assert_select '#mainNav' do
      assert_select 'li[data-section=dishes].active'
    end
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:dishes)
    assert_template 'dishes/index'
  end

  test 'should get show' do
    get :show, id: @dish
    assert_response :success
    assert_not_nil assigns(:dish)
    assert_template 'dishes/show'
  end

  test 'should get new if logged in' do
    do_login_as @user
    get :new
    assert_response :success
    assert_not_nil assigns(:dish)
    assert_template 'dishes/new'
  end

  test 'should not get new if not logged in' do
    assert_raise(Pundit::NotAuthorizedError) do
      get :new
    end
  end

  test 'should get edit if logged in' do
    do_login_as @user
    get :edit, id: @dish
    assert_response :success
    assert_not_nil assigns(:dish)
    assert_template 'dishes/edit'
  end

  test 'should not get edit if not logged in' do
    assert_raise(Pundit::NotAuthorizedError) do
      get :edit, id: @dish
    end
  end

  test 'should create dish if logged in' do
    do_login_as @user
    assert_difference('Dish.count', 1) do
      post :create, dish: {name: 'tortilla', info: 'corn goodness'}
    end
    assert_redirected_to dish_path(assigns(:dish))
  end

  test 'should not create dish if not logged in' do
    assert_raise(Pundit::NotAuthorizedError) do
      post :create, dish: {name: 'tortilla', info: 'corn goodness'}
    end
  end

  test 'should not accept invalid params' do
    do_login_as @user
    assert_no_difference('Dish.count') do
      post :create, dish: {invalid_param: 'garbage'}
    end
  end

  test 'should update dish if logged in' do
    do_login_as @user
    update = 'new info'
    assert_not @dish.info == update
    assert_no_difference('Dish.count') do
      put :update, id: @dish, dish: {name: @dish.name, info: update}
    end
    assert assigns(:dish).info == update
    assert_redirected_to dish_path(assigns(:dish))
  end

  test 'should not update dish if not logged in' do
    update = 'new info'
    assert_not @dish.info == update
    assert_raise(Pundit::NotAuthorizedError) do
      put :update, id: @dish, dish: {name: @dish.name, info: update}
    end
    assert_not @dish.info == update
  end

  test 'should destroy dish if logged in' do
    do_login_as @user
    assert_difference('Dish.count', -1) do
      delete :destroy, id: @dish
    end
    assert_redirected_to dishes_path
  end

  test 'should not destroy dish if not logged in' do
    assert_raise(Pundit::NotAuthorizedError) do
      delete :destroy, id: @dish
    end
    assert_not_nil Dish.find(@dish)
  end
end
