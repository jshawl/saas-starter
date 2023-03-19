class CreateIdentities < ActiveRecord::Migration[7.0]
  def change
    create_table :identities do |t|
      t.references :user, null: false, foreign_key: true
      t.string :uid, null: false
      t.string :provider, null: false
      t.string :email
      t.string :token
      t.string :refresh_token
      t.integer :token_expires_at
      t.timestamps
    end
  end
end
