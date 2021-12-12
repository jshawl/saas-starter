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
    end

    if current_user.stripe_customer_id
      @portal = Stripe::BillingPortal::Session.create({
        customer: current_user.stripe_customer_id,
        return_url: account_url,
      })['url']
    end
  end

  def subscribe
    @session =  Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      customer: current_user.stripe_customer_id,
      mode: 'subscription',
      line_items: [{
        price: Rails.application.credentials.stripe[:metered_price_id]
      }],
      success_url: "#{account_url}?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: "#{account_url}",
      allow_promotion_codes: true
    )
    redirect_to @session.url
  end
end