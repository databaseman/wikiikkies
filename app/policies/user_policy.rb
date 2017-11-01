class UserPolicy < ApplicationPolicy
  class Scope < Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve 
      scope.where.not(id: user.id)
    end
  end #Scope

  def premium?
    user.role?("admin") or user.role?("premium")
  end

end
