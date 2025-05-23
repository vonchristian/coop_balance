class Member < ApplicationRecord
  extend PercentActive
  extend BirthdayMonitoring
  include PgSearch::Model
  include Contactable
  include Addressing

  pg_search_scope :text_search, against: %i[first_name middle_name last_name]
  multisearchable against: %i[first_name last_name middle_name]
  enum :sex,          { male: 0, female: 1, other: 2 }
  enum :civil_status, { single: 0, married: 1, widow: 2, divorced: 3 }

  has_one_attached :signature_specimen
  has_one_attached :avatar

  has_many :entries,                  class_name: "AccountingModule::Entry", as: :commercial_document
  has_many :memberships,              class_name: "Cooperatives::Membership", as: :cooperator, dependent: :destroy
  has_many :savings,                  class_name: "DepositsModule::Saving", as: :depositor
  has_many :share_capitals,           class_name: "DepositsModule::ShareCapital", as: :subscriber
  has_many :time_deposits,            class_name: "DepositsModule::TimeDeposit", as: :depositor
  has_many :program_subscriptions,    class_name: "MembershipsModule::ProgramSubscription", as: :subscriber
  has_many :loans,                    class_name: "LoansModule::Loan", as: :borrower
  has_many :subscribed_programs,      class_name: "Cooperatives::Program", through: :program_subscriptions, source: :program
  has_many :organization_memberships, class_name: "Organizations::OrganizationMember", as: :organization_membership
  has_many :organizations,            through: :organization_memberships
  has_many :relationships,            as: :relationee
  has_many :relations,                as: :relationer
  has_many :beneficiaries,                dependent: :destroy
  has_many :loan_applications,            class_name: "LoansModule::LoanApplication", as: :borrower
  has_many :share_capital_applications,   class_name: "ShareCapitalsModule::ShareCapitalApplication", as: :subscriber
  has_many :savings_account_applications, as: :depositor
  has_many :time_deposit_applications,    class_name: "TimeDepositsModule::TimeDepositApplication", as: :depositor
  has_many :identifications,              class_name: "IdentificationModule::Identification", as: :identifiable

  validates :last_name, :first_name, presence: true, on: :update

  delegate :name, to: :current_organization, prefix: true, allow_nil: true
  before_save :update_birth_date_fields
  before_save :set_default_account_number
  # before_save :normalize_name

  def beneficiaries
    sc_beneficiaries = if share_capitals.present?
                         share_capitals.pluck(:beneficiaries).map { |b| b.present? ? [ "#{b} (SC)" ] : [] }
    else
                         []
    end
    maf_beneficiaries = if share_capitals.present?
                          share_capitals.pluck(:maf_beneficiaries).map { |b| b.present? ? [ "#{b} (MAF)" ] : [] }
    else
                          []
    end
    td_beneficiaries = if time_deposits.present?
                         time_deposits.not_withdrawn.pluck(:beneficiaries).map { |b| b.present? ? [ "#{b} (TD)" ] : [] }
    else
                         []
    end
    sd_beneficiaries = if savings.present?
                         savings.pluck(:beneficiaries).map { |b| b.present? ? [ "#{b} (SD)" ] : [] }
    else
                         []
    end
    (sc_beneficiaries + maf_beneficiaries + td_beneficiaries + sd_beneficiaries).uniq.compact.join(", ")
  end

  def self.retired
    where.not(retired_at: nil)
  end

  def self.for_cooperative(args = {})
    joins(:memberships).where("memberships.cooperative_id" => args[:cooperative].id)
  end

  def self.updated_at(args = {})
    return unless args[:from_date] && args[:to_date]

    from_date = args[:from_date] || latest.last_transaction_date
    to_date   = args[:to_date]   || oldest.last_transaction_date
    date_range = DateRange.new(from_date: from_date, to_date: to_date)
    where("last_transaction_date" => date_range.range)
  end

  def self.created_at(args = {})
    return unless args[:from_date] && args[:to_date]

    from_date = args[:from_date] || latest.last_transaction_date
    to_date   = args[:to_date]   || oldest.last_transaction_date
    date_range = DateRange.new(from_date: from_date, to_date: to_date)
    where("created_at" => date_range.range)
  end

  def self.oldest
    order(last_transaction_date: :asc).first
  end

  def self.latest
    order(last_transaction_date: :desc).first
  end

  def self.active_at(args = {})
    updated_at(args)
  end

  def self.has_birth_month_on(args = {})
    BirthdayQuery.new(self).has_birth_month_on(args)
  end

  def self.has_birthday_on(args = {})
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

  # for select2 referencing
  def name_and_details
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

  def recommended_co_makers
    Member.where(last_name: last_name)
  end

  def recommended_relationships
    Member.where(last_name: last_name)
  end

  def age
    return NullAge.new.age if date_of_birth.blank?

    ((Time.zone.now - date_of_birth.to_time) / 1.year.seconds).floor
  end

  def full_name
    if middle_name.present?
      "#{last_name}, #{first_name} #{middle_name}"
    else
      "#{last_name}, #{first_name}"
    end
  end

  def name_and_initial
    if middle_name.present?
      "#{last_name}, #{first_name} #{middle_name.first.titleize}."
    else
      "#{last_name}, #{first_name}"
    end
  end

  def first_and_last_name
    "#{first_name} #{last_name}"
  end

  def signatory_name
    first_middle_and_last_name
  end

  # for pdf signatories
  def first_middle_and_last_name
    if middle_name.present?
      "#{first_name.try(:titleize)} #{middle_name.first.upcase}. #{last_name.try(:titleize)}"
    else
      "#{first_name.try(:titleize)} #{last_name.try(:titleize)}"
    end
  end

  def default_last_transaction_date
    last_transaction_date || updated_at
  end

  def applied_loan_products
    LoansModule::LoanProduct.where(id: loans.not_cancelled.pluck(:loan_product_id).uniq)
  end

  def loans_for(args = {})
    loans.where(loan_product: args[:loan_product])
  end

  def activity_status(args = {})
    office    = args.fetch(:office)
    from_date = args.fetch(:from_date)
    to_date   = args.fetch(:to_date)
    activity  = entries.where(office: office).entered_on(from_date: from_date, to_date: to_date)
    if activity.present?
      "Active"
    else
      "Inactive"
    end
  end

  def activity_status_text_color(args = {})
    if activity_status(args) == "Active"
      "success"
    else
      "danger"
    end
  end

  def date_of_membership_for(cooperative:)
    membership = memberships.where(cooperative: cooperative).last
    return if membership.blank?

    membership.membership_date
  end

  private

  def set_default_account_number
    self.account_number ||= SecureRandom.uuid
  end

  def set_fullname
    self.fullname = full_name # used for slugs
  end

  def update_birth_date_fields
    return unless date_of_birth_changed?

    self.birth_month = date_of_birth ? date_of_birth.month : nil
    self.birth_day = date_of_birth ? date_of_birth.day : nil
    self.birth_year = date_of_birth ? date_of_birth.year : nil
  end

  def normalize_name
    self.first_name = TextNormalizer.new(text: first_name).propercase
    self.middle_name = TextNormalizer.new(text: middle_name).propercase
    self.last_name = TextNormalizer.new(text: last_name).propercase
  end
end
