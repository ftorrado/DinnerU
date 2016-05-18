ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods

  # (Copy from SessionsHelper) Logs user in
  # TODO: find better workaround than duplicating code
  def do_login_as(user, options = {})
    password    = options[:password]    || 'foobar'
    remember_me = options[:remember_me] || '1'
    if integration_test?
      post login_path, session: { email:       user.email,
                                  password:    password,
                                  remember_me: remember_me }
    else
      session[:user_id] = user.id
    end
  end

  # (Copy from SessionsHelper) Check if any user is logged in
  def is_logged_in?
    !session[:user_id].nil?
  end

  private

    # Returns true inside an integration test.
    def integration_test?
      defined?(post_via_redirect)
    end

  protected

    def users_setup
      @user = create(:user)
    end
    def users_teardown
      @user.destroy
    end

    def meals_setup
      @user = create(:user)
      @user2 = create(:user)
      @meal = create(:meal, user: @user)
      @private_meal = create(:meal, user: @user)
    end
    def meals_teardown
      @meal.destroy
      @private_meal.destroy
      @user.destroy
      @user2.destroy
    end

    def orders_setup
      @user = create(:user)
      @order = build(:order, user: @user)
      @meal = build(:meal, user: @user)
      @meal.orders << @order
      @meal.save
    end
    def orders_teardown
      @meal.destroy
      @user.destroy
    end

    def comments_setup
      orders_setup
      @comment = build(:comment, user: @user)
      @meal.comments << @comment
      @meal.save
    end
    def comments_teardown
      orders_teardown
    end

    def dishes_setup
      @user = create(:user)
      @dish = create(:dish)
    end
    def dishes_teardown
      @dish.destroy
      @user.destroy
    end
end
