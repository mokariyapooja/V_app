class ChangeFildType1User < ActiveRecord::Migration
  def change
    change_column :users, :device_id, :string
  end
end
