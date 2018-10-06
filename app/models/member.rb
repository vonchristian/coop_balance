class Member < ApplicationRecord
  include PgSearch
  include Addressable
  pg_search_scope :text_search, :against => [ :first_name, :middle_name, :last_name]
  multisearchable against: [:first_name, :last_name, :middle_name]
  enum sex: [:male, :female, :other]
  enum civil_status: [:single, :married, :widow, :divorced]

  has_one_attached :signature_specimen
  has_one_attached :avatar

  has_one :member_account #for devise login
  belongs_to :office,                 class_name: "CoopConfigurationsModule::Office"
  has_many :tins,                     as: :tinable
  has_many :entries,                  class_name: "AccountingModule::Entry",
                                      as: :commercial_document
  has_many :voucher_amounts,          class_name: "Vouchers::VoucherAmount",
                                      as: :commercial_document
  has_many :memberships,              as: :cooperator, dependent: :destroy
  has_many :savings,                  class_name: "MembershipsModule::Saving",
                                      as: :depositor
  has_many :share_capitals,           class_name: "MembershipsModule::ShareCapital",
                                      as: :subscriber
  has_many :time_deposits,            class_name: "MembershipsModule::TimeDeposit",
                                      as: :depositor
  has_many :program_subscriptions,    class_name: "MembershipsModule::ProgramSubscription",
                                      as: :subscriber
  has_many :member_occupations,       class_name: "MembershipsModule::MemberOccupation",
                                      dependent: :destroy
  has_many :occupations,              through: :member_occupations
  has_many :loans,                    class_name: "LoansModule::Loan",
                                      as: :borrower
  has_many :subscribed_programs,      class_name: "CoopServicesModule::Program",
                                      through: :program_subscriptions,
                                      source: :program
  has_many :sales_orders,             class_name: "StoreFrontModule::Orders::SalesOrder",
                                      as: :commercial_document
  has_many :sales_return_orders,      class_name: "StoreFrontModule::Orders::SalesReturnOrder",
                                      as: :commercial_document

  has_many :organization_memberships, class_name: "Organizations::OrganizationMember",
                                      as: :organization_membership
  has_many :organizations,            through: :organization_memberships
  has_many :relationships,            as: :relationee
  has_many :relations,                as: :relationer
  has_many :contacts, as: :contactable
  has_many :addresses, as: :addressable
  has_many :beneficiaries, dependent: :destroy


  delegate :number, to: :tin, prefix: true, allow_nil: true
  delegate :name, to: :office, prefix: true, allow_nil: true
  delegate :number, to: :current_contact, prefix: true, allow_nil: true
  delegate :number, to: :current_tin, prefix: true, allow_nil: true
  delegate :details, :complete_address, :barangay_name, :street_name, to: :current_address, prefix: true, allow_nil: true

  before_save :update_birth_date_fields
  # before_save :set_default_image, on: :create
  def self.updated_at(options={})
    if options[:from_date] && options[:to_date]
      date_range = DateRange.new(from_date: options[:from_date], to_date: options[:to_date])
      where('updated_at' => (date_range.start_date)..(date_range.end_date))
    end
  end

  def self.has_no_tin
    joins(:tins).where('tins.tinable_type')
  end

  def self.has_birth_month_on(args= {})
    BirthdayQuery.new(self).has_birth_month_on(args)
  end

  def self.has_birth_day_on(args= {})
    BirthdayQuery.new(self).has_birth_d
    ay_on(args)
  end

  def current_contact
    contacts.current
  end

  def current_address
    addresses.current_address
  end


  def current_tin
    tins.current
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

  def recommended_co_makers
    Member.where(last_name: self.last_name)
  end
  def recommended_relationships
    Member.where(last_name: self.last_name)
  end


  def age
    return "No Date of Birth" if date_of_birth.nil?
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

  def default_last_transaction_date
    last_transaction_date || updated_at
  end


  private

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
end
