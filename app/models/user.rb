class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  COMPANIES = ['Webteh', 'NOC']
  TITLES = ['developer', 'apprentice', 'junior developer', 'senior developer', 'Security Officer', 'COO', 'CTO', 'CEO', 'CSO']
  ROLES = [ 'user', 'manager', 'security' ]

  validates :company, inclusion: { in: COMPANIES }, presence: true
  validates :role, inclusion: { in: ROLES }, presence: true
  validates :title, presence: true
  validates :full_name, presence: true

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

end
