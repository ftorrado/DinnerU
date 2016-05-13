require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  setup :orders_setup
  teardown :orders_teardown

  test 'should be valid' do
    assert @order.valid?, @order.errors.full_messages
  end

  test 'user creator should be present' do
    assert_not_nil @order.user
    @order.user = nil
    assert_not @order.valid?
  end

  test 'description should not be too long' do
    @order.description = 'a' * 61
    assert_not @order.valid?
  end

  test 'can reference creator user' do
    assert_not_nil @order.user
    assert_not_nil User.find(@order.user)
  end

  test 'dishes can be add and removed' do
    dish = create(:dish)
    @order.dishes << dish
    assert @order.dishes.size == 1
    @order.dishes.delete(dish)
    assert_empty @order.dishes
  end
end
