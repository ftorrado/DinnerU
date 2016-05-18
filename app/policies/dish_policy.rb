# Policies for access to dish objects
class DishPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      # No need to be logged in to access
      scope.all
    end
  end
end
