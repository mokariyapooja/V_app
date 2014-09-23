class AddFildsGroup < ActiveRecord::Migration
  def change
    add_column :groups, :user_id, :integer
    add_column :groups, :group_name, :string
  end
end
