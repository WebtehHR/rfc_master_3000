# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :request_for_change do
    noc_tracking_number "MyString"
    webteh_tracking_number "MyString"
    type_network false
    type_servers false
    type_application false
    type_user_management false
    requested_by_id 1
    description_of_change "MyString"
    change_repair false
    change_removal false
    change_emergency false
    change_other false
    request_implement_window "2013-08-24"
    systems_affected "MyString"
    users_affected "MyString"
    criticality_of_change "MyString"
    test_plan "MyText"
    back_out_plan "MyText"
    management_approver_id 1
    cso_approver_id 1
    approval_status "MyString"
    approval_comments "MyString"
    change_scheduled_for "2013-08-24"
    approval_date "2013-08-24"
    implementor_id 1
    implementation_status "MyString"
    implement_comments "MyString"
    implementation_start "2013-08-24"
    implementation_end "2013-08-24"
  end
end
