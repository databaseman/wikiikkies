class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end #Scope

  def premium?
    user.role?("admin") or user.role?("premium")
  end

end
