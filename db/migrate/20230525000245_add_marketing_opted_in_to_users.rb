class AddMarketingOptedInToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :marketing_opted_in, :boolean, default: false
  end
end
