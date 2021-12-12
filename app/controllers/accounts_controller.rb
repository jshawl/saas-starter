class AccountsController < ApplicationController
  before_action :authenticate_user!
  def show
    if params[:session_id]
      @session = Stripe::Checkout::Session.retrieve(params[:session_id])
      p @session
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

    @products = Stripe::Product.list.map do |p|
      p.prices = Stripe::Price.list(product: p.id)
      p
    end
  end

  def subscribe
    session_data = {
      payment_method_types: ['card'],
      customer: current_user.stripe_customer_id,
      mode: params[:mode],
      line_items: [{
        price: params[:price_id]
      }],
      success_url: "#{account_url}?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: "#{account_url}",
      allow_promotion_codes: true
    }
    @session = begin
      Stripe::Checkout::Session.create(session_data)
    rescue Stripe::InvalidRequestError => e
      session_data[:line_items][0][:quantity] = "1"
      Stripe::Checkout::Session.create(session_data)
    end
    redirect_to @session.url
  end
end