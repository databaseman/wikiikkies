class CollaboratorsController < ApplicationController
  before_action :authenticate_user!

  def show
    @post=Post.find(params[:id])
    authorize @post
    @users=User.where.not( id: current_user.id ).paginate(page: params[:page], per_page: 10)
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
