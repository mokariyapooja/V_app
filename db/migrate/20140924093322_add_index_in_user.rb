class AddIndexInUser < ActiveRecord::Migration
  def change
     add_index :users, :mobile_number,unique: true
  end
end
