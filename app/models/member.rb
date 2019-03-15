class Member < ApplicationRecord
  include PgSearch

  include CurrentTin
  include Contactable
  include Addressable
  extend TinMonitoring
  extend PercentActive
  extend BirthdayMonitoring

  pg_search_scope :text_search, :against => [ :first_name, :middle_name, :last_name]
  multisearchable against: [:first_name, :last_name, :middle_name]
  enum sex: [:male, :female, :other]
  enum civil_status: [:single, :married, :widow, :divorced]

  has_one_attached :signature_specimen
  has_one_attached :avatar

  has_one :member_account #for devise login
  has_many :entries,                  class_name: "AccountingModule::Entry", as: :commercial_document
  has_many :voucher_amounts,          class_name: "Vouchers::VoucherAmount", as: :commercial_document
  has_many :memberships,              class_name: "Cooperatives::Membership", as: :cooperator, dependent: :destroy
  has_many :savings,                  class_name: "MembershipsModule::Saving", as: :depositor
  has_many :share_capitals,           class_name: "MembershipsModule::ShareCapital", as: :subscriber
  has_many :time_deposits,            class_name: "MembershipsModule::TimeDeposit", as: :depositor
  has_many :program_subscriptions,    class_name: "MembershipsModule::ProgramSubscription", as: :subscriber
  has_many :member_occupations,       class_name: "MembershipsModule::MemberOccupation", dependent: :destroy
  has_many :occupations,              through: :member_occupations
  has_many :loans,                    class_name: "LoansModule::Loan", as: :borrower
  has_many :subscribed_programs,      class_name: "Cooperatives::Program", through: :program_subscriptions, source: :program
  has_many :sales,                    class_name: "StoreFrontModule::Orders::SalesOrder", as: :commercial_document
  has_many :sales_returns,            class_name: "StoreFrontModule::Orders::SalesReturnOrder", as: :commercial_document
  has_many :organization_memberships, class_name: "Organizations::OrganizationMember",   as: :organization_membership
  has_many :organizations,            through: :organization_memberships
  has_many :relationships,            as: :relationee
  has_many :relations,                as: :relationer


  has_many :beneficiaries, dependent: :destroy
  has_many :loan_applications,            class_name: "LoansModule::LoanApplication", as: :borrower
  has_many :share_capital_applications,   as: :subscriber
  has_many :savings_account_applications, as: :depositor
  has_many :time_deposit_applications,    as: :depositor
  has_many :wallets, as: :account_owner
  validates :last_name, :first_name, presence: true, on: :update

  delegate :name, to: :current_organization, prefix: true, allow_nil: true
  before_save :update_birth_date_fields
  before_save :set_default_image, :set_default_account_number, on: :create
  before_save :normalize_name
  def self.retired
    where.not(retired_at: nil)
  end

  def self.for_cooperative(args={})
    joins(:memberships).where('memberships.cooperative_id' => args[:cooperative].id)
  end
  def self.updated_at(args={})
    if args[:from_date] && args[:to_date]
      from_date = args[:from_date] || latest.last_transaction_date
      to_date   = args[:to_date]   || oldest.last_transaction_date
      date_range = DateRange.new(from_date: from_date, to_date: to_date)
      where('last_transaction_date' => date_range.range)
    end
  end

  def self.created_at(args={})
    if args[:from_date] && args[:to_date]
      from_date = args[:from_date] || latest.last_transaction_date
      to_date   = args[:to_date]   || oldest.last_transaction_date
      date_range = DateRange.new(from_date: from_date, to_date: to_date)
      where('created_at' => date_range.range)
    end
  end

  def self.oldest
    order(last_transaction_date: :asc).first
  end

  def self.latest
    order(last_transaction_date: :desc).first
  end

  def self.active_at(args={})
    updated_at(args)
  end

  def self.has_birth_month_on(args= {})
    BirthdayQuery.new(self).has_birth_month_on(args)
  end

  def self.has_birthday_on(args= {})
    where(birth_day: args[:birth_day])
  end

  def retired?
    retired_at.present?
  end

  def current_organization
    organizations.current
  end

  def current_membership
    memberships.current
  end

  def name_and_details #for select2 referencing
    "#{full_name} (#{current_membership.membership_type.try(:titleize)})"
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

  def current_occupation
    occupations.current
  end

  def recommended_co_makers
    Member.where(last_name: self.last_name)
  end

  def recommended_relationships
    Member.where(last_name: self.last_name)
  end

  def age
    return NullAge.new.age if date_of_birth.blank?
    ((Time.zone.now - date_of_birth.to_time) / 1.year.seconds).floor
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

  def first_middle_and_last_name #for pdf signatories
    if middle_name.present?
      "#{first_name.titleize} #{middle_name.first.upcase}. #{last_name.titleize}"
    else
      "#{first_name.titleize} #{last_name.titleize}"
    end
  end

  def default_last_transaction_date
    last_transaction_date || updated_at
  end

  private
  def set_default_image
    if !self.avatar.attached?
      self.avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'default.png')), filename: 'default-image.png', content_type: 'image/png')
    end
  end

  def set_default_account_number
    self.account_number ||= SecureRandom.uuid
  end

  def set_fullname
    self.fullname = self.full_name #used for slugs
  end

  def update_birth_date_fields
    if date_of_birth_changed?
      self.birth_month = date_of_birth ? date_of_birth.month : nil
      self.birth_day = date_of_birth ? date_of_birth.day : nil
      self.birth_year = date_of_birth ? date_of_birth.year : nil
    end
  end
  
  def normalize_name
    self.first_name = TextNormalizer.new(text: self.first_name).propercase
    self.middle_name = TextNormalizer.new(text: self.middle_name).propercase
    self.last_name = TextNormalizer.new(text: self.last_name).propercase


  end
end
