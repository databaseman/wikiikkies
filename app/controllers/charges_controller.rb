class ChargesController < ApplicationController
  def index
  end

  def show
  end

  def upgrade
    premium = Role.where( name: "premium").first
    Assignment.create!( user: current_user, role: premium)
    flash[:success] = 'Your account has been upgraded to Premium'
    redirect_to root_path
  end

  def downgrade
    @private_posts = current_user.posts.where(private: true) # User private wiki list
  end

  def downgrade_user
    begin
      ActiveRecord::Base.transaction do
        premium = Role.where( name: "premium")
        current_user.assignments.where( role: premium ).destroy_all # Remove premium role assigment
        current_user.posts.update_all( private: false ) # Set all user posts to public
        # Remove collaboration on all user's posts
        Collaborator.where( "post_id in (select id from posts where user_id = ?)", current_user.id ).destroy_all
      end
      flash[:success] = 'Your account has been downgraded to Standard'
      redirect_to root_path
    rescue
      flash.now[:danger] = 'There was an error downgrading your account. Please try again.'
      render :edit # render the new view again
    end
  end

  def new
  end

  def create
  end

end #Class
