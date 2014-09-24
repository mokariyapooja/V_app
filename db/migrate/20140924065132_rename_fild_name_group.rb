class RenameFildNameGroup < ActiveRecord::Migration
  def change
    change_table :groups do |t|
      t.rename :group_name, :name
    end
  end
end
