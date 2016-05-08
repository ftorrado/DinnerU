class MealPolicy
  attr_reader :user, :meal

  def initialize(user, meal)
    @user = user
    @meal = meal
  end

  def index?
    @meals = policy_scope(Meal)
  end

  def show?
    if meal.is_private
      meal.user_id == user.id || meal.invited_users_ids.include?(user.id)
    else
      true
    end
  end

  def create?
    !user.is_guest?
  end

  def new?
    create?
  end

  def update?
    meal.user_id == user.id
  end

  def edit?
    update?
  end

  def destroy?
    meal.user_id == user.id
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.nil?
        scope.publicly_visible
      else
        scope.any_of({ is_visible: true },
                     { invited_users_ids: user.id },
                     { user_id: user.id })
      end
    end
  end
end
