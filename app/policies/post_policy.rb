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
        #scope.where( "private = ? OR user_id = ?", 'f', user.id ) + user.post_collaborations <== returns array
        #we don't want array. We want AR so we can use where and order clause in controller.
        #have to prefix column with table name posts.id in exists clause otherwise get wrong result in sqlite.
        scope.where( "private = ? OR user_id = ?", 'f', user.id )
        .or( scope.where( "exists (select 1 from collaborators c where c.post_id=posts.id and c.user_id=?)",user.id ) )
      end
    end
  end #class Scope

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
