# Policies for access to meal objects
class MealPolicy
  attr_reader :user, :meal

  def initialize(user, meal)
    @user = user
    @meal = meal
  end

  def index?
    true
  end

  def show?
    if user.nil?
      Meal.where(is_private: false)
        .where(id: meal.id).exists?
    else
      Meal.any_of({ is_private: false },
                  { is_private: true, invited_user_ids: user.id },
                  { is_private: true, user_id: user.id })
        .where(id: meal.id).exists?
    end

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
        scope.where(is_visible: true)
      else
        scope.any_of({ is_visible: true },
                     { is_visible: false, invited_user_ids: user.id },
                     { is_visible: false, user_id: user.id })
      end
    end
  end
end
