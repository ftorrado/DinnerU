require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  setup :orders_setup
  teardown :orders_teardown

  COUNT = 'Meal.find(@meal).orders.count'
  DISHES_COUNT = 'Meal.find(@meal).orders.find(@order).dishes.count'

  test 'should get show' do
    get :show, meal_id: @meal, id: @order
    assert_response :success
    assert_not_nil assigns(:meal)
    assert_not_nil assigns(:order)
    assert_template 'orders/show'
  end

  test 'should get new if logged in' do
    @meal.orders.clear
    @meal.save
    do_login_as @user
    get :new, meal_id: @meal
    assert_response :success
    assert_not_nil assigns(:meal)
    assert_not_nil assigns(:order)
    assert_template 'orders/new'
  end

  test 'should not get new if not logged in' do
    assert_raise(Pundit::NotAuthorizedError) do
      get :new, meal_id: @meal
    end
  end

  test 'should create order' do
    @user2 = create(:user)
    do_login_as @user2
    assert_difference(COUNT, 1) do
      post :create, meal_id: @meal, order: {description: 'new order'}
    end
    assert_redirected_to meal_order_path(assigns(:meal),
                                         assigns(:order))
    @user2.destroy
  end

  test 'should not create order missing permission' do
    @meal.is_private = true
    @meal.save
    @user2 = create(:user)
    do_login_as @user2
    assert_raise(Pundit::NotAuthorizedError) do
      post :create, meal_id: @meal, order: {description: 'new order'}
    end
    @user2.destroy
  end

  test 'should not create duplicate order' do
    do_login_as @user
    assert_raise(Pundit::NotAuthorizedError) do
      post :create, meal_id: @meal, order: {description: 'new order'}
    end
  end

  test 'should create order even with invalid params request' do
    @meal.orders.clear
    @meal.save
    do_login_as @user
    assert_difference(COUNT, 1) do
      post :create, meal_id: @meal, order: {invalid_param: 'garbage'}
    end
  end

  test 'should get edit if owner user' do
    do_login_as @user
    get :edit, meal_id: @meal, id: @order
    assert_response :success
    assert_not_nil assigns(:meal)
    assert_not_nil assigns(:order)
    assert_template 'orders/edit'
  end

  test 'should not get edit if not logged in or wrong user' do
    assert_raise(Pundit::NotAuthorizedError) do
      get :edit, meal_id: @meal, id: @order
    end
    @user2 = create(:user)
    do_login_as @user2
    assert_raise(Pundit::NotAuthorizedError) do
      get :edit, meal_id: @meal, id: @order
    end
    @user2.destroy
  end

  test 'should update order if owner user' do
    do_login_as @user
    new_description = 'edited order'
    assert_no_difference(COUNT) do
      put :update, meal_id: @meal, id: @order,
          order: {description: new_description}
    end
    @order = @meal.orders.find(@order.id)
    assert @order.description = new_description
    assert_redirected_to meal_order_path(assigns(:meal),
                                         assigns(:order))
  end

  test 'should destroy order if owner user' do
    do_login_as @user
    assert_difference(COUNT, -1) do
      delete :destroy, meal_id: @meal, id: @order
    end
    assert_redirected_to meal_path(assigns(:meal))
  end

  test 'should add dish to order if owner user' do
    do_login_as @user
    @dish = create(:dish)
    assert_difference(DISHES_COUNT, 1) do
      post :add_dish, meal_id: @meal, order_id: @order,
           dish_id: @dish
    end
    assert_redirected_to meal_order_path(assigns(:meal),
                                          assigns(:order))
    @dish.destroy
  end

  test 'should remove dish from order if owner user' do
    do_login_as @user
    @dish = create(:dish)
    @order.dishes << @dish
    @order.save
    assert_difference(DISHES_COUNT, -1) do
      delete :remove_dish, meal_id: @meal, order_id: @order,
             dish_id: @dish
    end
    assert_redirected_to meal_order_path(assigns(:meal),
                                         assigns(:order))
    @dish.destroy
  end
end
