require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  require 'test_helper'

  def setup
    @meal = build(:meal)
    @order = build(:order)
    @meal.orders << @order
    @meal.save
  end
  def teardown
    @meal.destroy
  end

  test 'should get index' do
    get :index, meal_id: @meal
    assert_response :success
    assert_not_nil assigns(:meal)
    assert_not_nil assigns(:orders)
    assert_template ' orders/index'
  end

  test 'should get show' do
    get :show, meal_id: @meal, id: @order
    assert_response :success
    assert_not_nil assigns(:meal)
    assert_not_nil assigns(:order)
    assert_template ' orders/show'
  end

  test 'should get new' do
    get :new, meal_id: @meal
    assert_response :success
    assert_not_nil assigns(:meal)
    assert_not_nil assigns(:order)
    assert_template ' meals/new'
  end

  test 'should create order' do
    assert_difference('Order.count', 1) do
      post :create, meal_id: @meal, order: build(:order)
    end
    assert_redirected_to order_path(assigns(:order))
  end

  test 'should create meal' do
    assert_raises(Exception) do
      post :create, meal_id: @meal, order: {invalid_param: 'garbage'}
    end
  end

  test 'should get edit' do
    get :edit, meal_id: @meal, id: @order
    assert_response :success
    assert_not_nil assigns(:meal)
    assert_not_nil assigns(:order)
    assert_template ' orders/edit'
  end

  test 'should update order' do
    assert_no_difference('Order.count') do
      post :update, meal_id: @meal, order: @order
    end
    assert_redirected_to order_path(assigns(:order))
  end

  test 'should destroy meal' do
    assert_no_difference('Order.count', -1) do
      post :destroy, meal_id: @meal, id: @order
    end
    assert_redirected_to orders_path
  end
end
