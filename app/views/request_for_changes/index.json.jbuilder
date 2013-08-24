json.array!(@request_for_changes) do |request_for_change|
  json.extract! request_for_change, :noc_tracking_number, :webteh_tracking_number, :type_network, :type_servers, :type_application, :type_user_management, :requested_by_id, :description_of_change, :change_repair, :change_removal, :change_emergency, :change_other, :request_implement_window, :systems_affected, :users_affected, :criticality_of_change, :test_plan, :back_out_plan, :management_approver_id, :cso_approver_id, :approval_status, :approval_comments, :change_scheduled_for, :approval_date, :implementor_id, :implementation_status, :implement_comments, :implementation_start, :implementation_end
  json.url request_for_change_url(request_for_change, format: :json)
end
