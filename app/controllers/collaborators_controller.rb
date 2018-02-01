class CollaboratorsController < ApplicationController
  before_action :authenticate_user!

  def show
    @post=policy_scope(Post).find(params[:id])
    authorize @post, :collaborate?
    # Grabbing both users and collaborations info now to reduce db query in show.html.erb
    # Can't use ? in joins
    base_query="LEFT OUTER JOIN collaborators
                          ON collaborators.user_id=users.id
                          AND collaborators.post_id=#{@post.id}
                        WHERE users.id != #{current_user.id}"
    search_query=base_query+" AND users.name like '%#{params[:name]}%'"
    if params[:name]
      @usersCollaboration=User.joins( search_query ).select( "users.id, users.name, users.email, collaborators.id cid").paginate(page: params[:page], per_page: 10)
    else
      @usersCollaboration=User.joins( base_query ).select( "users.id, users.name, users.email, collaborators.id cid").paginate(page: params[:page], per_page: 10)
    end
  end

  def new
  end

  def create
    @collaborator = Collaborator.new
    @collaborator.user_id=params[:user_id]
    @collaborator.post_id=params[:post_id]
    authorize @collaborator
    if @collaborator.save # Calling database save/insert command
      flash[:success] = 'User was added.'
      redirect_to action: "show", id: @collaborator.post_id
    else
      flash.now[:danger] = 'There was an error adding the user. Please try again.'
      redirect_to action: "show", id: @collaborator.post_id # render the new view again
    end
  end

  def destroy
    @collaborator = Collaborator.find(params[:id])
    authorize @collaborator
    @user=User.find(@collaborator.user_id)
    if @collaborator.destroy
      flash[:success] = "\"#{@user.name} (#{@user.email})\" was removed successfully."
      redirect_to action: "show", id: @collaborator.post_id
    else
      flash.now[:danger] = 'There was an error removing the user.'
      redirect_to action: "show", id: @collaborator.post_id
    end
  end

end
