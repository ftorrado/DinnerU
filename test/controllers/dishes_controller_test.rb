require 'test_helper'

class DishesControllerTest < ActionController::TestCase
  setup :dishes_setup
  teardown :dishes_teardown

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

  test 'should get new' do
    get :new
    assert_response :success
    assert_not_nil assigns(:dish)
    assert_template 'dishes/new'
  end

  test 'should get edit' do
    get :edit
    assert_response :success
    assert_not_nil assigns(:dish)
    assert_template 'dishes/edit'
  end

  test 'should create dish' do
    assert_difference('Dish.count', 1) do
      post :create, dish: {name: 'tortilla', info: 'corn goodness'}
    end
    assert_redirected_to dish_path(assigns(:dish))
  end

  test 'should not accept invalid params' do
    do_login_as @user
    assert_no_difference('Dish.count') do
      post :create, dish: {invalid_param: 'garbage'}
    end
  end

  test 'should update dish' do
    update = 'new info'
    assert_no_difference('Dish.count') do
      put :update, dish: {name: @dish.name, info: update}
    end
    assert assigns(:dish).info == update
    assert_redirected_to dish_path(assigns(:dish))
  end

  test 'should destroy dish' do
    assert_difference('Dish.count', -1) do
      delete :destroy, id: @dish
    end
    assert_redirected_to dishes_path
  end

  test 'should add dish to order' do
    orders_setup
    assert_no_difference('@meal.orders.count') do
      post :create, meal_id: @meal, order_id: @order, order:
                             {description: new_description}
    end
    assert_redirected_to meal_path(assigns(:meal))
    orders_teardown
  end

  test 'should remove dish from order' do
    orders_setup
    assert_difference('@meal.orders.count', -1) do
      delete :destroy, meal_id: @meal, id: @order
    end
    assert_redirected_to meal_path(assigns(:meal))
  end
end
