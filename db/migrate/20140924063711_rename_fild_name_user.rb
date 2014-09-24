class RenameFildNameUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.rename :devise_id, :device_id
      t.rename :devise_type, :device_type
    end
  end
end
