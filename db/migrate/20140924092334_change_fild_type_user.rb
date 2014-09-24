class ChangeFildTypeUser < ActiveRecord::Migration
  def change
    change_column :users, :mobile_number, :integer, null: false, limit: 8
  end
end
