require 'csv'
class Member < ApplicationRecord
  include PgSearch
  pg_search_scope :text_search, :against => [ :first_name, :middle_name, :last_name]
  multisearchable against: [:first_name, :last_name, :middle_name]
  enum sex: [:male, :female, :other]
  enum civil_status: [:single, :married, :widower, :divorced]

  belongs_to :office,              class_name: "CoopConfigurationsModule::Office"
  has_one :tin,                    as: :tinable
  has_many :entries,               class_name: "AccountingModule::Entry", as: :commercial_document
  has_many :voucher_amounts,       class_name: "Vouchers::VoucherAmount", as: :commercial_document #for temporary cration of debit adn creditrs
  has_many :memberships,           as: :cooperator
  has_many :savings,               class_name: "MembershipsModule::Saving",
                                   as: :depositor
  has_many :share_capitals,        class_name: "MembershipsModule::ShareCapital",
                                   as: :subscriber
  has_many :time_deposits,         class_name: "MembershipsModule::TimeDeposit",
                                   as: :depositor
  has_many :program_subscriptions, class_name: "MembershipsModule::ProgramSubscription",
                                   as: :subscriber
  has_many :member_occupations,    class_name: "MembershipsModule::MemberOccupation",
                                   dependent: :destroy
  has_many :occupations,           through: :member_occupations
  has_many :loans,                 class_name: "LoansModule::Loan",
                                   as: :borrower
  has_many :co_makered_loans,      class_name: "LoansModule::LoanCoMaker",
                                   as: :co_maker
  has_many :addresses,             as: :addressable
  has_many :subscribed_programs,      class_name: "CoopServicesModule::Program", through: :program_subscriptions, source: :program
  has_many :sales_orders,             class_name: "StoreFrontModule::Orders::SalesOrder",
                                      as: :commercial_document
  has_many :sales_return_orders,      class_name: "StoreFrontModule::Orders::SalesReturnOrder",
                                      as: :commercial_document
  has_many :real_properties,          as: :owner
  has_many :organization_memberships, class_name: "Organizations::OrganizationMember", as: :organization_membership
  has_many :organizations,            through: :organization_memberships
  has_many :relationships,            as: :relationee
  has_many :relations, as: :relationer


  delegate :number, to: :tin, prefix: true, allow_nil: true
  delegate :name, to: :office, prefix: true, allow_nil: true

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

  before_save :update_birth_date_fields

  def self.has_birthdays_on(month)
    BirthdayQuery.new(self).has_birthdays_on(month)
  end

  def name
    full_name
  end

  def latest_purchase_date
    if sales_orders.present?
      sales_orders.order(created_at: :asc).last.date
    else
      "No Purchases yet"
    end
  end
  def self.with_loans
    all.select{|a| a.loans.present? }
  end

  def total_savings
    savings.sum(&:balance)
  end

  def total_share_capitals
    share_capitals.sum(&:balance)
  end

  def total_purchases(options={})
    sales_orders.total(options)
  end

  def subscribed?(program)
    subscribed_programs.include?(program)
  end

  def current_occupation
    return "No Occupation entered" if occupations.blank?
    occupations.order(created_at: :asc).last
  end

  def current_address
    addresses.current_address
  end


  def recommended_co_makers
    Member.where(last_name: self.last_name)
  end
  def recommended_relationships
    Member.where(last_name: self.last_name)
  end


  def age
    return 'No Date of Birth' unless date_of_birth.present?
    days_alive = Date.today - date_of_birth
    years = (days_alive / 365).to_i
    months = ((days_alive % 365) / 30).to_i
    "#{years}.#{months}".to_f
  end


  def account_receivable_store_balance
    StoreFront.accounts_receivable_balance(self)
  end

  def full_name
    "#{last_name}, #{first_name} #{middle_name}"
  end
  def first_and_last_name
    "#{first_name} #{last_name}"
  end
  def current_address
    addresses.order(created_at: :asc).last.try(:details) || "Not Yet Entered"
  end

  private
  def set_fullname
    self.fullname = self.full_name #used for slugs
  end

  def update_birth_date_fields
    if date_of_birth_changed?
      self.birth_month = date_of_birth ? date_of_birth.month : nil
      self.birth_day = date_of_birth ? date_of_birth.day : nil
    end
  end
end
