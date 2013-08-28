class RequestForChange < ActiveRecord::Base

  has_paper_trail

  CRITICALITY = [ 'low', 'medium', 'high' ]
  APPROVAL_STATUSES = [ 'approved', 'rejected', 'uncertain' ]
  IMPLEMENTATION_STATUSES = [ 'implemented', 'failed' ]

  USER_DELEGATORS = [ :email, :name_with_description ]

  REQUEST_ATTRIBUTES = [
    :noc_tracking_url, :webteh_tracking_url, :type_network, :type_servers,
    :type_application, :type_user_management, :type_documentation, :description_of_change,
    :change_repair, :change_removal, :change_emergency, :change_other,
    :request_implement_window, :systems_affected, :users_affected,
    :criticality_of_change, :test_plan, :back_out_plan
  ]

  MANAGEMENT_APPROVAL_ATTRIBUTES = [
    :mgmt_approval_status, :mgmt_approval_comments, :change_scheduled_for, :implementor_id
  ]

  SECURITY_APPROVAL_ATTRIBUTES = [
    :sec_approval_status, :sec_approval_comments
  ]

  IMPLEMENTOR_ATTRIBUTES = [
    :implementation_status, :implement_comments, :implementation_start, :implementation_end
  ]

  
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
    o.validate :validate_type_of_rfc
    o.validates :description_of_change, presence: true
    o.validate :validate_type_of_change
    o.validates :systems_affected, presence: true
    o.validates :users_affected, presence: true
    o.validates :test_plan,     length: { minimum: 10, allow_blank: true }
    o.validates :back_out_plan, length: { minimum: 10, allow_blank: true }
    o.before_save :set_requestor
  end

  with_options if: lambda{ |rfc| rfc.edited_by_manager? } do |o|
    o.validates :mgmt_approval_status,  presence: true, inclusion: { in: APPROVAL_STATUSES }
    o.validate  :validate_implementor
    o.before_save :set_manager
  end

  with_options if: lambda{ |rfc| rfc.edited_by_security_officer? } do |o|
    o.validates :sec_approval_status, presence: true, inclusion: { in: APPROVAL_STATUSES }
    o.before_save :set_security_officer
  end

  with_options if: lambda{ |rfc| rfc.edited_by_implementor? } do |o|
    o.validates :implementation_status, inclusion: { in: IMPLEMENTATION_STATUSES }
  end
  # ============================== END:   validators ===========================


  # ======================== BEGIN: who is current user? =======================
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
  # ======================== END:   who is current user? =======================


  # ========================== BEGIN: set roles ================================
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
  # ========================== END:   set roles ================================


  # ========================== BEGIN: roles? ===================================
  def implementation_granted?
    mgmt_approval_status == 'approved' && sec_approval_status == 'approved'
  end

  def implementation_rejected?
    mgmt_approval_status == 'rejected' || sec_approval_status == 'rejected'
  end

  def at_least_partially_approved?
    mgmt_approval_status == 'approved' || sec_approval_status == 'approved'
  end

  # request section is editable unless partially approved and editor isn't a
  # good person
  def request_section_editable?
     !at_least_partially_approved? && (edited_by_requestor? || edited_by_manager?)
  end

  def management_section_editable?
    edited_by_manager?
  end

  def security_officer_section_editable?
    edited_by_security_officer?
  end

  def implementation_section_editable?
    edited_by_manager? || ( implementation_granted? && edited_by_implementor? )
  end
  # ========================== END:   roles? ===================================

  def rfc_id
    "RFC-#{3000+id}"
  end

  def implementation_status_for_show
    if implementation_granted?
      implementation_status.try(:humanize) || 'In progress'
    elsif implementation_rejected?
      "No, rejected by #{detect_approval_status_source('rejected').join(', ')}"
    else
      "Need approval from #{detect_approval_status_source('uncertain').join(', ')}"
    end
  end

  
  private

  # ======================== BEGIN: validators =================================
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
  # ======================== END:   validators =================================


  def _force_update_role? options
    changed? || options[:force]
  end

  def approval_status
    {
      manager:  mgmt_approval_status || 'uncertain',
      security: sec_approval_status || 'uncertain',
    }
  end

  def detect_approval_status_source status
    approval_status.map{|k,v| k if v == status }.compact
  end

  def validate_type_of_rfc
    # [:type_network, :type_servers, :type_application, :type_user_management, :type_documentation]
    rfc_type_attributes = REQUEST_ATTRIBUTES.reject{|x| not x.to_s =~ /^type_/}
    return true if rfc_type_attributes.detect{|x| send(x)}

    rfc_type_attributes.each{ |x| errors.add(x, 'select something') }
  end

  def validate_type_of_change
    # [:change_repair, :change_removal, :change_emergency, :change_other]
    change_type_attributes = REQUEST_ATTRIBUTES.reject{|x| not x.to_s =~ /^change_/}
    return true if change_type_attributes.detect{|x| send(x)}

    change_type_attributes.each{ |x| errors.add(x, 'select something') }
  end

end
