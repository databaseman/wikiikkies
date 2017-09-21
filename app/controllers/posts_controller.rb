class PostsController < ApplicationController

  def index
    @posts=Post.all
  end

  def new #create an object
    @post = Post.new
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
    @post = Post.new(post_params)
    if @post.save
      flash[:notice] = "Post has been created."
      redirect_to @post  #rails knows to goto post show page. You can also specify "redirect_to :action => :show"
    else
      flash.now[:alert] = "Post has not been created."
      render "new"
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = "Post has been updated."
      redirect_to @post
    else
      flash.now[:alert] = "Post has not been updated."
      render "edit"
    end
  end

  private
  def post_params
    params.require(:post).permit(:title, :body)
  end
end
