class AddPaypalSubcriptionIdToPayments < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :paypal_subscription_id, :string
  end
end
