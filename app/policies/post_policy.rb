class PostPolicy < ApplicationPolicy

  class Scope < Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve  #These are what user can see
      if user.role?("admin")
        scope.all
      else #User can only see public or own or collaborated posts
        scope.where( "private = ? OR user_id = ?", 'f', user.id ) + user.post_collaborations
      end
    end
  end #class Scope

  def create
    user.role?("admin") || user.role?("premium")
  end

  # Update if a public post; or owned by this user; or user is
  # part of the collaboration for this post; or an admin
  def update?
    !record.private? || record.user_id == user.id || record.user_collaborators.include?(user) || user.role?("admin")
  end

  # Same as update
  def edit?
    update?
  end

  # Same as update
  def show?
    update?
  end

  # Only if owner or admin
  def destroy?
    record.user_id == user.id || user.role?("admin")
  end

  # Allow managing collaboration on private post only, and user must be owner or admin
  def collaborate?
    record.private? && ( (record.user_id == user.id) || user.role?("admin") )
  end

  # Can make toggle post privacy if current user is a premium user and the owner or admin
  def checkbox?
    ( user.role?("premium") && (record.user_id == user.id) ) || user.role?("admin")
  end

end #class PostPolicy
