class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def increment_usage
    subscription = Stripe::Subscription.retrieve(stripe_subscription_id)
    Stripe::SubscriptionItem.create_usage_record(
      subscription.items.first.id,
      {quantity: 1, timestamp: Time.now.to_i},
    )
  end
end
