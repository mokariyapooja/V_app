class AddFiledNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :sender_id, :integer
    add_column :notifications, :resever_id, :integer
    add_column :notifications, :in_range, :boolean
    
  end
end
