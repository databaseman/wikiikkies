class RolesController < ApplicationController
  before_action :set_role, only: [:show, :edit, :update, :destroy]

    def index
      @roles=Role.all
    end

    def new #create an object
      @role = Role.new
    end

    #render vs redirect_to
    #-----------------------
    #render will render a particular view using the instance variables available in the action.
    #For example if a render was used for the new action, when a user goes to /new, the new action
    #in the controller is called, instance variables are created and then passed to the new view.
    #Rails creates the html for that view and returns it back to the user’s browser. This is what you
    # would consider a normal page load.
    #
    #redirect_to will send a redirect to the user’s browser telling it to re-request a new URL.
    #Then the browser will send a new request to that URL and it will go through the action for that URL,
    #oblivious to the fact that it was redirected to. None of the variables created in the action that caused
    #the redirect will be available to the redirected view. This is what happens when you click on ‘Create’ in
    #a form and the object is created and you’re redirected to the edit view for that object.

    #flash vs flash_now
    #------------------
    #flash messages display on the very next page load
    #flash.now flash messages display on the current page

    def create #create an object & database record
      @role = Role.new(role_params)
      if @role.save
        flash[:notice] = "Role has been created."
        redirect_to @role  #rails knows to goto role show page. You can also specify "redirect_to :action => :show"
      else
        flash.now[:alert] = "Role has not been created."
        render "new"
      end
    end

    def show
    end

    def edit
    end

    def update
      if @role.update(role_params)
        flash[:notice] = "Role has been updated."
        redirect_to @role
      else
        flash.now[:alert] = "Role has not been updated."
        render "edit"
      end
    end

    def destroy
      @role.destroy
      flash[:notice] = "Role has been deleted."
      redirect_to roles_path
    end

    private

    def set_role
      @role = Role.find(params[:id])
      rescue ActiveRecord::RecordNotFound
      flash[:alert] = "The role you were looking for could not be found."
      redirect_to roles_path
    end

    def role_params
      params.require(:role).permit(:name, :description) #Seccurity. Allow only these fields to be updated/entered
    end
end
