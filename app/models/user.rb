class User < ApplicationRecord
  include Addressing
  include CurrentTin
  include PgSearch::Model
  include Contactable
  has_one_attached :avatar
  pg_search_scope :text_search, :against => [:first_name, :last_name]
  multisearchable against: [:first_name, :last_name]
  LOAN_APPROVERS = ["Manager", "Loan Officer"]
  TREASURY_PERSONNELS = ["Teller", "Treasurer"]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable
  enum sex: [:male, :female]
  enum role: [:system_administrator,
              :general_manager,
              :branch_manager,
              :loan_officer,
              :bookkeeper,
              :teller,
              :stock_custodian,
              :sales_clerk,
              :treasurer,
              :accountant,
              :collector]
  has_one :wallet, as: :account_owner
  belongs_to :store_front, optional: true

  belongs_to :cooperative
  belongs_to :office,                 class_name: "Cooperatives::Office"
  has_many :purchases,                class_name: "StoreFrontModule::Orders::SalesOrder", as: :commercial_document
  has_many :sold_orders,              class_name: "StoreFrontModule::Orders::SalesOrder",
                                      foreign_key: 'employee_id'
  has_many :returned_sales_orders,    class_name: "StoreFrontModule::Orders::SalesReturnOrder",
                                      foreign_key: 'employee_id'
  has_many :loans,                    class_name: "LoansModule::Loan", as: :borrower
  has_many :memberships,              as: :cooperator
  has_many :savings,                  class_name: "MembershipsModule::Saving", as: :depositor
  has_many :share_capitals,           class_name: "MembershipsModule::ShareCapital", as: :subscriber
  has_many :time_deposits,            class_name: "MembershipsModule::TimeDeposit", as: :depositor
  has_many :sales_orders,             class_name: "StoreFrontModule::Orders::SalesOrder", as: :commercial_document
  has_many :sales_return_orders,      class_name: "StoreFrontModule::Orders::SalesReturnOrder", as: :commercial_document
  has_many :entries,                  class_name: "AccountingModule::Entry", foreign_key: 'recorder_id'
  has_many :voucher_amounts,          class_name: "Vouchers::VoucherAmount", foreign_key: 'recorder_id' # for adding amounts on voucher
  has_many :vouchers,                 as: :payee
  has_many :prepared_vouchers,        class_name: "Voucher", foreign_key: 'preparer_id'
  has_many :disbursed_vouchers,       class_name: "Voucher", foreign_key: 'disburser_id'

  has_many :organization_memberships, class_name: "Organizations::OrganizationMember", as: :organization_membership
  has_many :organizations,            through: :organization_memberships
  has_many :program_subscriptions,    class_name: "MembershipsModule::ProgramSubscription", as: :subscriber
  has_many :subscribed_programs,      through: :program_subscriptions, class_name: "CoopServicesModule::Program"

  has_many :employee_cash_accounts,   class_name: "Employees::EmployeeCashAccount", foreign_key: 'employee_id'
  has_many :cash_accounts,            class_name: "AccountingModule::Account", through: :employee_cash_accounts, source: :cash_account
  has_many :carts,                    class_name: 'StoreFrontModule::Cart'
  delegate :name, :address, :contact_number, :abbreviated_name, :logo, to: :cooperative, prefix: true
  delegate :name, to: :office, prefix: true, allow_nil: true

  delegate :name, :abbreviated_name, to: :cooperative, prefix: true
  delegate :name, to: :store_front, prefix: true, allow_nil: true
  before_save :set_default_image

  def self.has_birthdays_on(month)
    where(birth_month: month).order(:birth_day)
  end
  def self.cash_accounts
    ids = Employees::EmployeeCashAccount.where(employee_id: self.ids).pluck(:cash_account_id)
    AccountingModule::Account.where(id: ids)
  end

  def current_occupation
    role
  end

  def full_name
    name
  end

  def name_and_details #for select2 referencing
    "#{full_name} (#{role.titleize})"
  end

  def default_cash_account
    if employee_cash_accounts.present?
      employee_cash_accounts.default_cash_account
    end
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

  def account_receivable_store_balance
    AccountsReceivableStore.new.balance(self)
  end

  def self.loan_approvers
    all.select{|a| User::LOAN_APPROVERS.include?(a.role.titleize)}
  end

  def age
    return 'No Date of Birth' unless date_of_birth.present?
    days_alive = Date.today - date_of_birth
    years = (days_alive / 365).to_i
    months = ((days_alive % 365) / 30).to_i
    "#{years}.#{months}".to_f
  end

  def name  #for voucher index
    first_and_last_name
  end

  def first_and_last_name
    "#{first_name} #{last_name}"
  end

  def first_middle_and_last_name #report signatory
    if middle_name.present?
      "#{first_name.titleize} #{middle_name.first.upcase}. #{last_name.titleize}"
    else
      "#{first_name.titleize} #{last_name.titleize}"
    end
  end

  def latest_purchase_date
    orders.last.date || Time.zone.now
  end

  private
  def set_default_image
    if !avatar.attached?
      self.avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'default.png')), filename: 'default-image.png', content_type: 'image/png')
    end
  end
end
