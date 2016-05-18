# Policies for access to orders inside meal objects
class OrderPolicy
  attr_reader :user, :order

  def initialize(user, order)
    @user = user
    @order = order
  end

  # Show list of orders on meal if can show meal
  def index?
    order && MealPolicy.new(user, order.meal).show?
  end

  def show?
    index?
  end

  def create?
    user && order && !order.meal.has_order_from?(user) &&
      MealPolicy.new(user, order.meal).participate?
  end

  def new?
    create?
  end

  def update?
    user && order && order.user == user &&
      MealPolicy.new(user, order.meal).participate?
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end
end
