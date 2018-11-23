class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!, only: [:index]
  before_action :set_user, only: [:destroy, :edit, :update]
  @row_count=15

  def index
    base_query="LEFT OUTER JOIN assignments ON assignments.user_id=users.id WHERE 1=1"
    name_query=base_query+" AND users.name like '%#{params[:name]}%'"
    email_query=base_query+" AND users.email like '%#{params[:email]}%'"

    if params[:name]
      @usersAssignment=User.joins( name_query )
      .order("name")
      .select( "users.id, users.name, users.email, assignments.id aid").paginate(page: params[:page], per_page: @row_count)
    elsif params[:email]
      @usersAssignment=User.joins( email_query )
      .order("email")
      .select( "users.id, users.name, users.email, assignments.id aid").paginate(page: params[:page], per_page: @row_count)
    else
      @usersAssignment=User.joins( base_query )
      .order("name")
      .select( "users.id, users.name, users.email, assignments.id aid").paginate(page: params[:page], per_page: @row_count)
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
      redirect_to new_user_path(@user)
    else
      flash.now[:alert] = "User has not been created."
      render "new"
    end
  end

  def show
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "User has been updated."
      redirect_to users_index_path
    else
      flash.now[:alert] = "User has not been updated."
      render "edit"
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    flash[:alert] = "The user you were looking for could not be found."
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)  #Seccurity. Allow only these fields to be updated/entered
  end

  def authorize_admin!
    unless current_user.role?("admin")
      redirect_to root_path, alert: "You must be an admin to do that."
    end
  end

end
