class TimeDepositApplicationProcessing
  include ActiveModel::Model
  attr_accessor :time_deposit_product_id, :depositor_id, :depositor_type,
  :cash_account_id, :reference_number, :date, :amount, :description, :term,
  :employee_id, :voucher_account_number, :account_number, :beneficiaries

  validates :reference_number, :beneficiaries, :time_deposit_product_id, :amount, :date, :description, :term, :cash_account_id, presence: true
  validates :amount, :term, numericality: true

  def process!
    ActiveRecord::Base.transaction do
      create_time_deposit_application
    end
  end

  def find_voucher
    Voucher.find_by(account_number: voucher_account_number)
  end
  def find_time_deposit_application
    TimeDepositApplication.find_by(account_number: account_number)
  end

  private
  def create_time_deposit_application
    time_deposit_application = TimeDepositApplication.create!(
      time_deposit_product_id: time_deposit_product_id,
      depositor_id:            depositor_id,
      depositor_type:          depositor_type,
      term:                    term,
      date_deposited:          date,
      account_number:          account_number,
      amount:                  amount,
      cooperative:             find_employee.cooperative,
      beneficiaries:           beneficiaries
    )
    create_voucher(time_deposit_application)
  end
  def create_voucher(time_deposit_application)
    voucher = Voucher.new(
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
      amount: amount,
      commercial_document: time_deposit_application
    )
    voucher.voucher_amounts.credit.build(
      cooperative: find_employee.cooperative,
      account: credit_account,
      amount: amount,
      commercial_document: time_deposit_application)
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
  def find_time_deposit_product
    CoopServicesModule::TimeDepositProduct.find(time_deposit_product_id)
  end
end
