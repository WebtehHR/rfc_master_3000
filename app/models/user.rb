class User < ActiveRecord::Base

  has_paper_trail

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :validatable,
         :recoverable, :rememberable, :trackable

  COMPANIES = ['Webteh', 'NOC']
  TITLES = [
    'apprentice', 'junior developer', 'senior developer', 'QA staff', 'support',
    'security officer',
    'network admin', 'system admin',
    'COO', 'CTO', 'CEO', 'CSO',
    '*other*',
    'windows freak', 'Sheldon'
  ]
  ROLES = [ 'user', 'manager', 'security' ]

  validates :company, presence: true, inclusion: { in: COMPANIES }
  validates :role, presence: true, inclusion: { in: ROLES }
  validates :title, presence: true, inclusion: { in: TITLES }
  validates :full_name, presence: true

  # validates email
  validates :email, :presence => true
  validates :email, :uniqueness => true, :allow_blank => true, :if => :email_changed? # check uniq for email ever
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :if => :email_changed?

  # validates password
  message = "Your password must contain a capital letter, two numbers, a symbol,<br/>an inspiring message, a spell, a gang sign, a hieroglyph and the blood of a virgin".html_safe
  validates :password,
    :presence => true,
    :length => 8..30,
    :format => { with: /(?=.*\d)(?=.*[a-z])(?=.*[A-Z])/, message: message },
    :confirmation => true,
    :if => :password_required?

  def self.current_user
    Thread.current[:current_user]
  end

  def name_with_description
    "#{full_name} (#{company} #{title})"
  end

  def normal_user?
    role == 'user'
  end

  def manager?
    role == 'manager'
  end

  def security_officer?
    role == 'security'
  end

  # Checks whether a password is needed or not. For validations only.
  # Passwords are always required if it's a new record, or if the password
  # or confirmation are being set somewhere.
  def password_required?
    !persisted? || !password.blank? || !password_confirmation.blank?
  end


end
