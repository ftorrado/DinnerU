require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  require 'test_helper'

  setup :orders_setup
  teardown :orders_teardown

  test 'should get show' do
    get :show, meal_id: @meal, id: @order
    assert_response :success
    assert_not_nil assigns(:meal)
    assert_not_nil assigns(:order)
    assert_template 'orders/show'
  end

  test 'should get new' do
    get :new, meal_id: @meal
    assert_response :success
    assert_not_nil assigns(:meal)
    assert_not_nil assigns(:order)
    assert_template 'meals/new'
  end

  test 'should create order' do
    byebug
    assert_difference('@meal.orders.count', 1) do
      post :create, meal_id: @meal, order: {description: 'new order'}
    end
    assert_redirected_to order_path(assigns(:order))
  end

  test 'should not accept invalid params' do
    post :create, meal_id: @meal, order: {invalid_param: 'garbage'}
  end

  test 'should get edit' do
    get :edit, meal_id: @meal, id: @order
    assert_response :success
    assert_not_nil assigns(:meal)
    assert_not_nil assigns(:order)
    assert_template 'orders/edit'
  end

  test 'should update order' do
    assert_no_difference('@meal.orders.count') do
      post :update, meal_id: @meal, id: @order, order:
                             {description: 'edited order'}
    end
    assert_redirected_to meal_path(assigns(:meal))
  end

  test 'should destroy order' do
    assert_no_difference('@meal.orders.count', -1) do
      post :destroy, meal_id: @meal, id: @order
    end
    assert_redirected_to meal_path(assigns(:meal))
  end
end
