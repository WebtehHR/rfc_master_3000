require 'test_helper'

class RequestForChangesControllerTest < ActionController::TestCase
  setup do
    @request_for_change = request_for_changes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:request_for_changes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create request_for_change" do
    assert_difference('RequestForChange.count') do
      post :create, request_for_change: { approval_comments: @request_for_change.approval_comments, approval_date: @request_for_change.approval_date, approval_status: @request_for_change.approval_status, back_out_plan: @request_for_change.back_out_plan, change_emergency: @request_for_change.change_emergency, change_other: @request_for_change.change_other, change_removal: @request_for_change.change_removal, change_repair: @request_for_change.change_repair, change_scheduled_for: @request_for_change.change_scheduled_for, criticality_of_change: @request_for_change.criticality_of_change, cso_approver_id: @request_for_change.cso_approver_id, description_of_change: @request_for_change.description_of_change, implement_comments: @request_for_change.implement_comments, implementation_end: @request_for_change.implementation_end, implementation_start: @request_for_change.implementation_start, implementation_status: @request_for_change.implementation_status, implementor_id: @request_for_change.implementor_id, management_approver_id: @request_for_change.management_approver_id, noc_tracking_number: @request_for_change.noc_tracking_number, request_implement_window: @request_for_change.request_implement_window, requested_by_id: @request_for_change.requested_by_id, systems_affected: @request_for_change.systems_affected, test_plan: @request_for_change.test_plan, type_application: @request_for_change.type_application, type_network: @request_for_change.type_network, type_servers: @request_for_change.type_servers, type_user_management: @request_for_change.type_user_management, users_affected: @request_for_change.users_affected, webteh_tracking_number: @request_for_change.webteh_tracking_number }
    end

    assert_redirected_to request_for_change_path(assigns(:request_for_change))
  end

  test "should show request_for_change" do
    get :show, id: @request_for_change
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @request_for_change
    assert_response :success
  end

  test "should update request_for_change" do
    patch :update, id: @request_for_change, request_for_change: { approval_comments: @request_for_change.approval_comments, approval_date: @request_for_change.approval_date, approval_status: @request_for_change.approval_status, back_out_plan: @request_for_change.back_out_plan, change_emergency: @request_for_change.change_emergency, change_other: @request_for_change.change_other, change_removal: @request_for_change.change_removal, change_repair: @request_for_change.change_repair, change_scheduled_for: @request_for_change.change_scheduled_for, criticality_of_change: @request_for_change.criticality_of_change, cso_approver_id: @request_for_change.cso_approver_id, description_of_change: @request_for_change.description_of_change, implement_comments: @request_for_change.implement_comments, implementation_end: @request_for_change.implementation_end, implementation_start: @request_for_change.implementation_start, implementation_status: @request_for_change.implementation_status, implementor_id: @request_for_change.implementor_id, management_approver_id: @request_for_change.management_approver_id, noc_tracking_number: @request_for_change.noc_tracking_number, request_implement_window: @request_for_change.request_implement_window, requested_by_id: @request_for_change.requested_by_id, systems_affected: @request_for_change.systems_affected, test_plan: @request_for_change.test_plan, type_application: @request_for_change.type_application, type_network: @request_for_change.type_network, type_servers: @request_for_change.type_servers, type_user_management: @request_for_change.type_user_management, users_affected: @request_for_change.users_affected, webteh_tracking_number: @request_for_change.webteh_tracking_number }
    assert_redirected_to request_for_change_path(assigns(:request_for_change))
  end

  test "should destroy request_for_change" do
    assert_difference('RequestForChange.count', -1) do
      delete :destroy, id: @request_for_change
    end

    assert_redirected_to request_for_changes_path
  end
end
