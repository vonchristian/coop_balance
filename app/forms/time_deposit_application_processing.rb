class TimeDepositApplicationProcessing
  include ActiveModel::Model
  attr_accessor :time_deposit_product_id, :depositor_id, :depositor_type,
                :cash_account_id, :reference_number, :date, :amount, :description, :number_of_days,
                :employee_id, :voucher_account_number, :account_number, :beneficiaries

  validates :reference_number, :beneficiaries, :time_deposit_product_id, :amount, :date, :description, :number_of_days, :cash_account_id, presence: true
  validates :amount, :number_of_days, numericality: true

  def process!
    ActiveRecord::Base.transaction do
      create_time_deposit_application
    end
  end

  def find_voucher
    TreasuryModule::Voucher.find_by(account_number: voucher_account_number)
  end

  def find_time_deposit_application
    find_office.time_deposit_applications.find_by(account_number: account_number)
  end

  private

  def create_time_deposit_application
    time_deposit_application = find_office.time_deposit_applications.build(
      time_deposit_product_id: time_deposit_product_id,
      depositor_id: depositor_id,
      depositor_type: depositor_type,
      number_of_days: number_of_days,
      date_deposited: date,
      account_number: account_number,
      amount: amount,
      cooperative: find_employee.cooperative,
      beneficiaries: beneficiaries
    )
    create_accounts(time_deposit_application)
    time_deposit_application.save!
    create_voucher(time_deposit_application)
  end

  def create_accounts(time_deposit_application)
    ::AccountCreators::TimeDepositApplication.new(time_deposit_application: time_deposit_application).create_accounts!
  end

  def create_voucher(time_deposit_application)
    voucher = TreasuryModule::Voucher.new(
      account_number: voucher_account_number,
      payee_id: depositor_id,
      payee_type: depositor_type,
      preparer: find_employee,
      office: find_employee.office,
      cooperative: find_employee.cooperative,
      description: description,
      reference_number: reference_number,
      date: date
    )
    voucher.voucher_amounts.debit.build(
      cooperative: find_employee.cooperative,
      account: cash_account,
      amount: amount
    )
    voucher.voucher_amounts.credit.build(
      cooperative: find_employee.cooperative,
      account: time_deposit_application.liability_account,
      amount: amount
    )
    voucher.save!
  end

  def credit_account
    find_time_deposit_product.account
  end

  def cash_account
    AccountingModule::Account.find(cash_account_id)
  end

  def find_employee
    User.find(employee_id)
  end

  def find_office
    find_employee.office
  end

  def find_time_deposit_product
    CoopServicesModule::TimeDepositProduct.find(time_deposit_product_id)
  end
end
