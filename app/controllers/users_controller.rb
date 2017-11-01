class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users=policy_scope(User).paginate(page: params[:page], per_page: 10)
  end

  def show
  end

  def destroy
    @user.destroy
    flash[:notice] = "User #{@user.name} #{@user.email} has been deleted."
    redirect_to users_path
  end

  private

  def set_user
    @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    flash[:alert] = "The user you were looking for could not be found."
    redirect_to users_path
  end

  def user_params
    params.require(:user).permit(:name, :email)  #Seccurity. Allow only these fields to be updated/entered
  end
end
