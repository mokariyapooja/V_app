class AddFiledToAuthenticationToken < ActiveRecord::Migration
  def change
    add_column :authentication_tokens, :user_id, :integer
    add_column :authentication_tokens, :auth_token, :string
  end
end
