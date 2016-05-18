# Policies for access to meal objects
class MealPolicy
  attr_reader :user, :meal

  def initialize(user, meal)
    @user = user
    @meal = meal
  end

  # Meals can be hidden so you send the link to the event
  def index?
    @meals = scope.where(is_visible: true)
  end

  def show?
    scope.where(id: meal.id).exists?
  end

  def create?
    !user.nil? && !user.is_guest
  end

  def new?
    create?
  end

  def update?
    !user.nil? && meal.user == user
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  # Permission for placing orders on meals, would not necessarily
  # be the same as the "show?" permission
  def participate?
    !user.nil? && show?
  end

  def scope
    Pundit.policy_scope!(user, Meal)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.nil?
        scope.where(is_private: false)
      else
        scope.any_of({ is_private: false },
                     { is_private: true, invited_users_ids: user.id },
                     { is_private: true, user_id: user.id })
      end
    end
  end
end
