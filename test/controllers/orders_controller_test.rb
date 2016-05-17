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
    assert_template 'orders/_form'
  end

  test 'should create order' do
    josh = create(:josh)
    do_login_as josh
    assert_difference('@meal.orders.count', 1) do
      post :create, meal_id: @meal, order: {description: 'new order'}
    end
    assert_redirected_to order_path(assigns(:order))
    josh.destroy
  end

  test 'should not create duplicate order' do
    do_login_as @user
    assert_no_difference('@meal.orders.count') do
      post :create, meal_id: @meal, order: {description: 'new order'}
    end
  end

  test 'should not accept invalid params' do
    @meal.orders.clear
    do_login_as @user
    assert_no_difference('@meal.orders.count') do
      post :create, meal_id: @meal, order: {invalid_param: 'garbage'}
    end
  end

  test 'should get edit' do
    get :edit, meal_id: @meal, id: @order
    assert_response :success
    assert_not_nil assigns(:meal)
    assert_not_nil assigns(:order)
    assert_template 'orders/edit'
  end

  test 'should update order' do
    new_description = 'edited order'
    assert_no_difference('@meal.orders.count') do
      post :update, meal_id: @meal, id: @order, order:
                             {description: new_description}
    end
    assert_redirected_to meal_path(assigns(:meal))
  end

  test 'should destroy order' do
    @meal.orders << @order
    assert @meal.save
    assert_difference('@meal.orders.count', -1) do
      post :destroy, meal_id: @meal, id: @order
    end
    assert_redirected_to meal_path(assigns(:meal))
  end
end
