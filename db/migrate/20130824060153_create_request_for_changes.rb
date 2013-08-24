class CreateRequestForChanges < ActiveRecord::Migration
  def change
    create_table :request_for_changes do |t|
      # requestor attributes
      t.string :noc_tracking_url
      t.string :webteh_tracking_url
      t.boolean :type_network
      t.boolean :type_servers
      t.boolean :type_application
      t.boolean :type_user_management
      t.integer :requestor_id
      t.string :description_of_change
      t.boolean :change_repair
      t.boolean :change_removal
      t.boolean :change_emergency
      t.boolean :change_other
      t.date :request_implement_window
      t.string :systems_affected
      t.string :users_affected
      t.string :criticality_of_change
      t.text :test_plan
      t.text :back_out_plan

      # management attributes
      t.integer :management_approver_id
      t.string :mgmt_approval_status
      t.string :mgmt_approval_comments
      t.date :change_scheduled_for
      t.date :mgmt_decision_date

      # security officer attributes
      t.integer :security_approver_id
      t.string :sec_approval_status
      t.string :sec_approval_comments
      t.date :sec_decision_date

      # implementor attributes
      t.integer :implementor_id
      t.string :implementation_status
      t.string :implement_comments
      t.date :implementation_start
      t.date :implementation_end

      t.timestamps
    end
  end
end
