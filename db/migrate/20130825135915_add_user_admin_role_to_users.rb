class AddUserAdminRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_admin, :boolean
  end
end
