require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  check_navigation_section do
    assert_select '#mainNav' do
      assert_select 'li[data-section=users].active'
    end
  end

  test 'should get new' do
    get :new
    assert_response :success
  end
end
