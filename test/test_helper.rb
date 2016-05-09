ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods

  protected

    def users_setup
      @user = create(:user)
    end
    def users_teardown
      @user.destroy
    end

    def meals_setup
      @user = create(:user)
      @meal = create(:meal)
      @private_meal = create(:meal)
    end
    def meals_teardown
      @meal.destroy
      @private_meal.destroy
    end

    def orders_setup
      @meal = build(:meal)
      @order = build(:order)
      @meal.orders << @order
      @meal.save
    end
    def orders_teardown
      @meal.destroy
    end

    def dishes_setup
      @dish = create(:dish)
    end
    def dishes_teardown
      @dish.destroy
    end
end
