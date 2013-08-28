class AddDocsToRequestForChange < ActiveRecord::Migration
  def change
    add_column :request_for_changes, :type_documentation, :boolean
  end
end
