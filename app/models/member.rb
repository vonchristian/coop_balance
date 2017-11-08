require 'csv'
class Member < ApplicationRecord
  include Avatarable
  include PgSearch
  extend FriendlyId
  friendly_id :fullname, use: :slugged
  pg_search_scope :text_search, :against => [:passbook_number, :first_name, :middle_name, :last_name, :fullname]
  multisearchable against: [:passbook_number, :first_name, :last_name, :middle_name, :fullname]
  enum sex: [:male, :female, :other]
  enum civil_status: [:single, :married, :widower, :divorced]
  delegate :regular_member?, to: :membership
  before_validation :set_fullname
  validates :fullname, uniqueness: { message: 'is already registered'}

  has_one :tin, as: :tinable
  has_one :membership, as: :memberable
  has_many :member_occupations, dependent: :destroy
  has_many :occupations, through: :member_occupations
  has_many :loans, class_name: "LoansModule::Loan", as: :borrower
  has_many :co_makered_loans, class_name: "LoansModule::LoanCoMaker", as: :co_maker
  has_many :addresses, as: :addressable
  has_many :savings, class_name: "MembershipsModule::Saving", as: :depositor
  has_many :share_capitals, class_name: "MembershipsModule::ShareCapital", as: :subscriber
  has_many :time_deposits, class_name: "MembershipsModule::TimeDeposit", as: :depositor
  has_many :program_subscriptions, class_name: "MembershipsModule::ProgramSubscription"
  has_many :programs, through: :program_subscriptions
  has_many :orders, class_name: "StoreModule::Order", as: :customer
  has_many :real_properties, as: :owner
  has_many :organization_memberships, class_name: "OrganizationMember", as: :organization_membership
  has_many :organizations, through: :organization_memberships
  accepts_nested_attributes_for :tin, :addresses, :membership
  delegate :number, to: :tin, prefix: true, allow_nil: true
  delegate :membership_type, to: :membership, allow_nil: true

  has_attached_file :avatar,
  styles: { large: "120x120>",
           medium: "70x70>",
           thumb: "40x40>",
           small: "30x30>",
           x_small: "20x20>"},
  default_url: ":style/profile_default.jpg",
  :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
  :url => "/system/:attachment/:id/:style/:filename"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  after_commit :set_fullname, on: [:create, :update]
  after_commit :subscribe_to_programs
  before_save :update_birth_date_fields
  def self.with_loans
    all.select{|a| a.loans.present? }
  end
  def current_occupation
    return "No Occupation entered" if occupations.blank?
    occupations.order(created_at: :asc).last
  end
  def self.has_birthdays_on(month)
    where(birth_month: month).order(:birth_day)
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Member.create!(row.to_hash)
    end
  end
  def recommended_co_makers
    Member.where(last_name: self.last_name)
  end

  def age
    return 'No Date of Birth' unless date_of_birth.present?
    days_alive = Date.today - date_of_birth
    years = (days_alive / 365).to_i
    months = ((days_alive % 365) / 30).to_i
    "#{years}.#{months}".to_f
  end

  def name #for search results
    full_name
  end

  def account_receivable_store_balance
    StoreCredit.new.balance(self)
  end

  def full_name
    "#{last_name} #{first_name} #{middle_name}"
  end
  def first_and_last_name
    "#{first_name} #{last_name}"
  end
  def current_address
    addresses.order(created_at: :asc).last.try(:details)
  end
  def avatar_text
    first_name.chr
  end
  private
  def set_fullname
    self.fullname = self.full_name #used for slugs
  end
  def subscribe_to_programs
    CoopServicesModule::Program.subscribe(self)
  end
  def update_birth_date_fields
    if date_of_birth_changed?
      self.birth_month = date_of_birth ? date_of_birth.month : nil
      self.birth_day = date_of_birth ? date_of_birth.day : nil
    end
  end
end
