require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  it "handles a missing post correctly" do
    get :show, params: { id: "not-here" } 
    expect(response).to redirect_to(posts_path)
    message = "The post you were looking for could not be found."
    expect(flash[:alert]).to eq message
  end
end
