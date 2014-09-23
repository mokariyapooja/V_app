class AddFiledToUser < ActiveRecord::Migration
  def change
    add_column :users, :user_name, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :mobile_number, :integer
    add_column :users, :devise_id, :integer
    add_column :users, :devise_type, :string
  end
end
