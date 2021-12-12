class AddStripeCustomerIdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :stripe_customer_id, :string
    add_column :users, :stripe_subscription_id, :string
  end
end
