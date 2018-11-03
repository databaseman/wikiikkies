class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!, only: [:index]
  before_action :set_user, only: [:destroy]

  def index
    if params[:name]
      @users=policy_scope(User).where("name LIKE ?", "%#{params[:name]}%").order("name").paginate(page: params[:page], per_page: 10)
    elsif params[:email]
      @users=policy_scope(User).where("email LIKE ?", "%#{params[:email]}%").order("email").paginate(page: params[:page], per_page: 10)
    else
      @users=policy_scope(User).order("name").paginate(page: params[:page], per_page: 10)
    end
  end

  def destroy
    @user.destroy
    flash[:notice] = "User #{@user.name} #{@user.email} has been deleted."
    if current_user.role?("admin")
      redirect_to users_index_path
    else
      redirect_to root_path
    end
  end

  def new
    @user=User.new
  end

  def create
    @user=User.new
    @user.name=params[:user][:name]
    @user.email=params[:user][:email]
    @user.password=params[:user][:password]
    if @user.save
      role = Role.where( name: 'premium').first
      Assignment.create!( user: @user, role: role)
      flash[:notice] = "User has been created as a Premium user."
      redirect_to new_users_path(@user)
    else
      flash.now[:alert] = "User has not been created."
      render "new"
    end
  end

  def show
  end

  private

  def set_user
    @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    flash[:alert] = "The user you were looking for could not be found."
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit(:name, :email)  #Seccurity. Allow only these fields to be updated/entered
  end

  def authorize_admin!
    unless current_user.role?("admin")
      redirect_to root_path, alert: "You must be an admin to do that."
    end
  end

end
