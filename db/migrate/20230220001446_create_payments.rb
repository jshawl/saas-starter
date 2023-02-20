class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments  do |t|
      t.string :paypal_id
      t.references :user
      t.json :details
      t.timestamps
    end
  end
end
