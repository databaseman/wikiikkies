class CollaboratorPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  # Post has to be private, and can add collaborators if you are the owner or if you are an admin
  def create?
    post=Post.find(record.post_id)
    post.private? && ( (post.user_id==user.id) || user.role?("admin") )
    rescue ActiveRecord::RecordNotFound
    flash[:alert] = "The post you were looking for could not be found."
    redirect_to post_path
  end

  def destroy?
    create?
  end

end
