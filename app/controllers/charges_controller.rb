class ChargesController < ApplicationController
  def index
  end

  def show
  end

  def downgrade
    @private_posts = current_user.posts.where(private: true) # User private wiki list
  end

  def downgrade_posts
    #Change User wikis from private to public and user to standard
    if ( downgradeUser( current_user ) )
      flash[:success] = 'Your account has been downgraded to Standard'
      redirect_to root_path
    else
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
      current_user.premium! # prefer using the enum methods for brevity and clarity
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

  private

  def downgradeUser( user )
    premium = Role.select('id').where( name: "premium").first
    user.assignments.where( role_id: premium.id ).first.destroy &&
    user.posts.update_all( private: false ) &&
    user.posts.collaborators.destroy_all
  end

end #Class
