class User < ApplicationRecord
  LOAN_APPROVERS = ["Manager", "Loan Officer"]
  WITH_CASH_ON_HAND = ["Treasurer", "Teller", "Sales Clerk"]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable
  enum sex: [:male, :female, :others]
  enum role: [:system_administrator,
              :manager,
              :loan_officer,
              :bookkeeper,
              :teller,
              :stock_custodian,
              :sales_clerk,
              :treasurer,
              :accountant,
              :human_resource_officer,
              :accounting_clerk,
              :collector]
  belongs_to :cash_on_hand_account, class_name: "AccountingModule::Account", foreign_key: 'cash_on_hand_account_id'
  has_one :current_address, as: :addressable, class_name: "Address"
  belongs_to :department
  belongs_to :cooperative
  belongs_to :salary_grade
  has_one :membership, as: :memberable
  has_many :loans, class_name: "LoansModule::Loan", as: :borrower
  has_many :co_makered_loans, class_name: "LoansModule::LoanCoMaker", as: :co_maker
  has_many :savings, class_name: "MembershipsModule::Saving", as: :depositor
  has_many :share_capitals, class_name: "MembershipsModule::ShareCapital", as: :subscriber
  has_many :time_deposits, class_name: "MembershipsModule::TimeDeposit", as: :depositor
  has_many :orders, class_name: "StoreModule::Order", as: :customer
  has_many :entries, class_name: "AccountingModule::Entry", foreign_key: 'recorder_id'
  has_many :fund_transfers, class_name: "AccountingModule::Entry", as: :commercial_document
  has_many :appraised_properties, class_name: "Appraisal", foreign_key: 'appraiser_id'
  has_many :voucher_amounts, class_name: "Vouchers::VoucherAmount", as: :commercial_document # for adding amounts on voucher
  has_many :vouchers, as: :payee, class_name: "Voucher"
  has_many :employee_contributions, foreign_key: 'employee_id'
  has_many :real_properties, as: :owner
  has_many :contributions, through: :employee_contributions

  has_many :organization_memberships, class_name: "OrganizationMember", as: :organization_membership
  has_many :organizations, through: :organization_memberships

  delegate :name, :amount, to: :salary_grade, prefix: true, allow_nil: true
  delegate :name, to: :department, prefix: true, allow_nil: true
  delegate :name, :address, :contact_number, :logo, to: :cooperative, prefix: true
  delegate :regular_member?, to: :membership
  delegate :membership_type, to: :membership, allow_nil: true


  has_attached_file :avatar,
  styles: { large: "120x120>",
           medium: "70x70>",
           thumb: "40x40>",
           small: "30x30>",
           x_small: "20x20>"},
  default_url: ":style/profile_default.jpg",
  :path => ":rails_root/public/system/:attachment/:id/:basename_:style.:extension",
  :url => "/system/:attachment/:id/:basename_:style.:extension"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  def self.cash_on_hand_accounts
    user_accounts = all.collect{|a| a.cash_on_hand_account_id }.compact
    accounts = []
    user_accounts.each do |account|
      accounts << AccountingModule::Account.find(account)
    end
    accounts
  end

  def recommended_co_makers
    User.where(last_name: self.last_name)
  end

  def current_occupation
    role
  end

  def full_name
    name
  end

  def account_receivable_store_balance
    StoreCredit.new.balance(self)
  end

  def cash_advance_total
    AccountingModule::Account.find_by(name: "Advances to Officers, Employees and Members").debit_entries.where(commercial_document_id: self.id)
  end

  def self.with_cash_on_hands
    all.select{|a| WITH_CASH_ON_HAND.include?(a.role.titleize) }
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

  # def cash_on_hand_account
  #   if treasurer?
  #     AccountingModule::Asset.find_by(name: "Cash on Hand (Treasury)")
  #   elsif teller?
  #     AccountingModule::Asset.find_by(name: "Cash on Hand (Teller)")
  #   elsif sales_clerk?
  #     AccountingModule::Asset.find_by(name: "Cash on Hand (Teller)")
  #   end
  # end
  def fund_transfer_total
    fund_transfers.fund_transfer.map{ |a| a.debit_amounts.distinct.sum(:amount) }.sum
  end

  def payable_amount
    voucher_amounts.sum(:amount)
  end

end
