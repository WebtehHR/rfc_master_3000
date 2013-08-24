class AddCompanyAndTitleAndNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :company, :string
    add_column :users, :full_name, :string
    add_column :users, :title, :string
  end
end
