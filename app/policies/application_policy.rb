# Default permissions for Pundit
class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    @records = scope.where(is_visible: true)
  end

  def show?
    scope.where(id: record.id).exists?
  end

  def create?
    !user.nil? && !user.is_guest
  end

  def new?
    create?
  end

  def update?
    return false if user.nil?
    record.user == user
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if !user.nil? && !user.is_guest
        scope.all
      else
        scope.none
      end
    end
  end
end
