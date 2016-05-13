require 'test_helper'

class MealTest < ActiveSupport::TestCase
  setup :meals_setup
  teardown :meals_teardown

  test 'should be valid' do
    assert @meal.valid?, @meal.errors.full_messages
  end

  test 'user creator should be present' do
    @meal.user = nil
    assert_not @meal.valid?
  end

  test 'name should be present' do
    @meal.name = '  '
    assert_not @meal.valid?
  end

  test 'name should not be too short' do
    @meal.name = 'a' * 4
    assert_not @meal.valid?
  end

  test 'name should not be too long' do
    @meal.name = 'a' * 1
    assert_not @meal.valid?
  end

  test 'description should not be too long' do
    @meal.description = 'a' * 121
    assert_not @meal.valid?
  end

  test 'location should not be too long' do
    @meal.location = 'a' * 121
    assert_not @meal.valid?
  end

  test 'can reference creator user' do
    assert_not @meal.user.nil?
    user_creator = User.find(@meal.user_id)
    assert_not user_creator.nil?
  end

  test 'orders can be add' do
    @order = build(:order)
    @meal.add_order @order
    assert @meal.orders.size == 1
  end

  test 'orders can be removed' do
    @meal.orders.delete(@order)
    assert @meal.orders.empty?
  end

  test 'users can be invited' do
    @meal.invite_user @user
    assert @meal.invited_users.size == 1
  end

  test 'users are not invited twice' do
    @meal.invite_user @user
    assert @meal.invited_users.size == 1
  end

  test 'users invitations can be removed' do
    @meal.invited_users.delete(@user)
    assert @meal.invited_users.size == 0
  end
end
