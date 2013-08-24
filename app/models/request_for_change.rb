class RequestForChange < ActiveRecord::Base

  CRITICALITY = [ 'low', 'medium', 'high' ]
  APPROVAL_STATUSES = [ 'approved', 'rejected', 'uncertain' ]
  IMPLEMENTATION_STATUSES = [ 'implemented', 'failed' ]

  USER_DELEGATORS = [ :email, :name_with_description ]

  belongs_to :requestor, :class_name => 'User'
  belongs_to :management_approver, :class_name => 'User'
  belongs_to :security_approver, :class_name => 'User'
  belongs_to :implementor, :class_name => 'User'

  delegate *USER_DELEGATORS, to: :requestor, prefix: true, allow_nil: true
  delegate *USER_DELEGATORS, to: :management_approver, prefix: true, allow_nil: true
  delegate *USER_DELEGATORS, to: :security_approver, prefix: true, allow_nil: true
  delegate *USER_DELEGATORS, to: :implementor, prefix: true, allow_nil: true

  # ============================== BEGIN: validators ===========================
  with_options if: lambda{ |rfc| rfc.edited_by_requestor? } do |o|
    o.validates :criticality_of_change, inclusion: { in: CRITICALITY }, presence: true
    o.validate  :validate_tracking_url
    o.validates :description_of_change, presence: true
    o.validates :systems_affected, presence: true
    o.validates :users_affected, presence: true
    o.validates :test_plan,     length: { minimum: 10, allow_blank: true }
    o.validates :back_out_plan, length: { minimum: 10, allow_blank: true }
    o.before_save :set_requestor
  end

  with_options if: lambda{ |rfc| rfc.edited_by_manager? } do |o|
    o.validates :mgmt_approval_status,  inclusion: { in: APPROVAL_STATUSES }
    o.validates :mgmt_approval_comments, presence: true
    o.validate  :validate_implementor
    o.before_save :set_manager
  end

  with_options if: lambda{ |rfc| rfc.edited_by_security_officer? } do |o|
    o.validates :sec_approval_status,   inclusion: { in: APPROVAL_STATUSES }
    o.validates :sec_approval_comments, presence: true
    o.before_save :set_security_officer
  end

  with_options if: lambda{ |rfc| rfc.edited_by_implementor? } do |o|
    o.validates :implementation_status, inclusion: { in: IMPLEMENTATION_STATUSES }
  end


  # ============================== END:   validators ===========================

  def edited_by_requestor?
    !persisted? || requestor == User.current_user
  end

  def edited_by_manager?
    return false if edited_by_requestor?
    return true if User.current_user.manager?
  end

  def edited_by_security_officer?
    return false if edited_by_requestor?
    return true if User.current_user.security_officer?
  end

  def edited_by_implementor?
    return false if edited_by_manager?
    return false if edited_by_security_officer?
    return false unless implementation_granted?
    return true if implementor == User.current_user
  end

  def set_requestor options = {}
    if edited_by_requestor?
      self.requestor ||= User.current_user
      self.requestor = User.current_user if _force_update_role?(options)
    end
    true
  end

  def set_manager options = {}
    if edited_by_manager?
      self.management_approver ||= User.current_user
      self.management_approver = User.current_user if _force_update_role?(options)
    end
    true
  end

  def set_security_officer options = {}
    if edited_by_security_officer?
      self.security_approver ||= User.current_user
      self.security_approver = User.current_user if _force_update_role?(options)
    end
    true
  end

  def implementation_granted?
    mgmt_approval_status == 'approved' && sec_approval_status == 'approved'
  end

  def request_editable?
    not( mgmt_approval_status == 'approved' || sec_approval_status == 'approved' )
  end

  
  private

  def validate_tracking_url
    company = User.current_user.company

    if company == 'Webteh' || webteh_tracking_url.present?
      unless webteh_tracking_url.to_s =~ /https:\/\/webteh.lighthouseapp.com\/projects\/.*\/tickets\/[0-9]+/
        errors.add(:webteh_tracking_url, "must be a Lighthouse URL")
      end
    end
    if company == 'NOC' || noc_tracking_url.present?
      unless noc_tracking_url.to_s =~ /https:\/\/jira.poslovniservisi.com\/browse\/WEB-[0-9]+/
        errors.add(:noc_tracking_url, "must be a Jira (Webteh project) URL")
      end
    end
  end

  def validate_implementor
    if mgmt_approval_status == 'approved' and implementor.blank?
      errors.add(:implementor, "can't be blank if implementation is approved")
    else
      if implementor == management_approver
        errors.add(:implementor, "can't be same person as managment approver")
      end
      if implementor == security_approver
        errors.add(:implementor, "can't be same person as security approver")
      end
    end
  end

  def _force_update_role? options
    changed? || options[:force]
  end


end
