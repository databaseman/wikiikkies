class ChargesController < ApplicationController
  def index
  end

  def show
  end

  def upgrade # old upgrade without stripe
    premium = Role.where( name: "premium").first
    Assignment.create!( user: current_user, role: premium)
    flash[:success] = 'Your account has been upgraded to Premium'
    redirect_to root_path
  end

  def downgrade
    @private_posts = current_user.posts.where(private: true) # User private wiki list
  end

  def downgrade_user
    begin
      ActiveRecord::Base.transaction do
        premium = Role.where( name: "premium")
        current_user.assignments.where( role: premium ).destroy_all # Remove premium role assigment
        current_user.posts.update_all( private: false ) # Set all user posts to public
        # Remove collaboration on all user's posts
        Collaborator.where( "post_id in (select id from posts where user_id = ?)", current_user.id ).destroy_all
      end
      flash[:success] = 'Your account has been downgraded to Standard'
      redirect_to root_path
    rescue
      flash.now[:danger] = 'There was an error downgrading your account. Please try again.'
      render :edit # render the new view again
    end
  end

  def new
    @stripe_btn_data = {
      key: "#{ Rails.configuration.stripe[:publishable_key] }",
      description: "Wikiikki Premium Membership - #{current_user.name}",
      #amount: Amount.default
      amount: 10_00
    }
  end

  def create
    # Creates a Stripe Customer object, for associating
    # with the charge
    customer = Stripe::Customer.create(
      email: current_user.email,
      card: params[:stripeToken]
    )

    # Where the real magic happens
    charge = Stripe::Charge.create(
      customer: customer.id, # Note -- this is NOT the user_id in your app
      #amount: Amount.default,
      amount: 10_00,
      description: "Wikiikki Premium Membership - #{current_user.email}",
      currency: 'usd'
    )

    # Change User role to premium
    #User.find(current_user.id).update_attribute( :role, 'premium')
    #flash[:notice] = "Thanks for all the money, #{current_user.email}! Feel free to pay me again."
    #redirect_to root_path # or wherever

    if charge.paid  # https://stripe.com/docs/api/ruby#charges
      premium = Role.where( name: "premium").first
      Assignment.create!( user: current_user, role: premium)
      flash[:success] = "Payment received from #{current_user.email}."
      redirect_to root_path # or wherever
    end
    # Stripe will send back CardErrors, with friendly messages
    # when something goes wrong.
    # This `rescue block` catches and displays those errors.
    rescue Stripe::CardError => e
      flash[:danger] = e.message
      redirect_to new_charge_path
  end # create

end #Class
