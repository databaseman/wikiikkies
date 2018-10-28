class F1lesController < ApplicationController
  before_action :authenticate_user!

  def index
     @post=policy_scope(Post).find(params[:post_id])
     authorize @post, :update?
     @f1les = @post.f1les
  end

  def new
     @f1le = F1le.new
  end

  def create
     @f1le = F1le.new(f1le_params)
     @f1le.post_id=params[:post_id]
     if @f1le.save # Calling database save/insert command
       flash[:success] = 'File was added.'
       redirect_to post_f1les_path
     else
       flash.now[:danger] = 'There was an error adding file . Please try again.'
       redirect_to action: "index", id: @f1le.post_id # render the new view again
     end

  end

  def destroy
      @post=policy_scope(Post).find(params[:post_id])
      authorize @post, :update?
      @f1le = F1le.find(params[:id])
      @f1le.destroy
      redirect_to post_f1les_path, notice:  "The file #{@f1le.name} has been deleted."
  end

  private
    def f1le_params
      params.require(:f1le).permit(:name, :attachment, :post_id)
    end
end
