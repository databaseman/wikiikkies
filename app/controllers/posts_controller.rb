#
# Post must belongs to a user, but other people can do everything else with the post,
# thus only new and create needs to be associated with a post.
#
class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy, :collaborate]
  @row_count=15

  def index #All own, public, and collaborations
    #Using order clause instead of sort_by will do the sort and 10 records limit on the database side instead of
    #bringing everything over and sort on the client side.
    #However, the order clause calls the dbs two extra times: 1 with the same query and another for a select count(*)? for the same predicates. Why?
    #It is still faster and probably going to scale better that the sort_by.
    if params[:title]
      @posts = policy_scope(Post).where('title LIKE ?', "%#{params[:title]}%").order("title").paginate(page: params[:page], per_page: @row_count)
    else
      @posts=policy_scope(Post).order("title").paginate(page: params[:page], per_page: @row_count)
    end
  end

  def new #create an object. A post must belong to a user
    @post = current_user.posts.build #build set foreign key user_id automatically.
  end

  def owner_index #own only
    #It calls the database again, using the scope definition and added an AND with the new where clause.
    if params[:title]
      @posts = policy_scope(Post).where("user_id=? AND title LIKE ?", current_user.id, "%#{params[:title]}%").order( "title" ).paginate(page: params[:page], per_page: @row_count)
    else
      @posts=policy_scope(Post).where( "user_id = ?", current_user.id ).order("title").paginate(page: params[:page], per_page: @row_count)
    end
  end

  def collaborate_index #Other's & own collaborations
    main_posts=policy_scope(Post).where( "posts.user_id = ? AND exists (select 1 from collaborators c where c.post_id=posts.id)", current_user.id)
          .or(policy_scope(Post).where( "exists (select 1 from collaborators c where c.post_id=posts.id and c.user_id=?)",current_user.id ))

    if params[:title]
      @posts = main_posts.where('title LIKE ?', "%#{params[:title]}%").order("title").paginate(page: params[:page], per_page: @row_count)
    else
      @posts=main_posts.order("title").order("title").paginate(page: params[:page], per_page: @row_count)
    end
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
    @post = current_user.posts.build(post_params) #build set foreign key user_id automatically. rest set through post_params
    if @post.save
      flash[:notice] = "Post has been created."
      redirect_to @post  #rails knows to goto post show page. You can also specify "redirect_to :action => :show"
    else
      flash.now[:alert] = "Post has not been created."
      render "new"
    end
  end

  def show
  end

  def edit
  end

  def update
    if @post.update(post_params)
      flash[:notice] = "Post has been updated."
      redirect_to @post
    else
      flash.now[:alert] = "Post has not been updated."
      render "edit"
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = "Post has been deleted."
    redirect_to posts_path
  end


  private

  def set_post
    @post = Post.find(params[:id])
    authorize @post
    rescue ActiveRecord::RecordNotFound
    flash[:alert] = "The post you were looking for could not be found."
    redirect_to post_path
  end

  def post_params
    params.require(:post).permit(:title, :body, :private, :attachment )  #Seccurity. Allow only these fields to be updated/entered
  end
end
