class RequestForChange < ActiveRecord::Base

  CRITICALITY = [ 'low', 'medium', 'high' ]
  APPROVAL_STATUSES = [ 'approved', 'rejected' ]
  IMPLEMENTATION_STATUSES = [ 'implemented', 'failed' ]

  USER_DELEGATORS = [ :email ]

  validate :criticality_of_change, inclusion: { in: CRITICALITY }
  validate :approval_status, inclusion: { in: APPROVAL_STATUSES }
  validate :implementation_status, inclusion: { in: IMPLEMENTATION_STATUSES }


  belongs_to :requestor, :class_name => 'User'
  belongs_to :management_approver, :class_name => 'User'
  belongs_to :security_approver, :class_name => 'User'

  delegate *USER_DELEGATORS, to: :requestor, prefix: true, allow_nil: true
  delegate *USER_DELEGATORS, to: :management_approver, prefix: true, allow_nil: true
  delegate *USER_DELEGATORS, to: :security_approver, prefix: true, allow_nil: true

end
