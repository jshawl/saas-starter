class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def new_payment_method_session(return_url)
    Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      customer: stripe_customer_id,
      mode: 'subscription',
      line_items: [{
        price: Rails.application.credentials.stripe[:price_id]
      }],
      success_url: "#{return_url}?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: "#{return_url}",
      allow_promotion_codes: true
    )
  end

  def increment_usage
    subscription = Stripe::Subscription.retrieve(stripe_subscription_id)
    Stripe::SubscriptionItem.create_usage_record(
      subscription.items.first.id,
      {quantity: 1, timestamp: Time.now.to_i},
    )
  end
end
