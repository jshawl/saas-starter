class AccountsController < ApplicationController
  before_action :authenticate_user!
  def show
    if params[:session_id]
      @session = Stripe::Checkout::Session.retrieve(params[:session_id])
      current_user.update(
        stripe_customer_id: @session.customer,
        stripe_subscription_id: @session.subscription
      )
      redirect_to account_path
    else
      @session = current_user.new_payment_method_session(account_url)
    end

    if current_user.stripe_customer_id
      @portal = Stripe::BillingPortal::Session.create({
        customer: current_user.stripe_customer_id,
        return_url: account_url,
      })['url']
    end
  end
end