class SavingsAccountApplicationProcessing
  include ActiveModel::Model
  attr_accessor :saving_product_id, :depositor_id, :depositor_type,
  :cash_account_id, :reference_number, :date, :amount, :description,
  :employee_id, :voucher_account_number, :account_number, :beneficiaries

  validates :reference_number, :amount, :date, :saving_product_id, presence: true

  def process!
    ActiveRecord::Base.transaction do
      create_savings_account_application
    end
  end

  def find_voucher
    Voucher.find_by(account_number: voucher_account_number)
  end
  def find_savings_account_application
    SavingsAccountApplication.find_by(account_number: account_number)
  end

  private
  def create_savings_account_application
    savings_account_application = SavingsAccountApplication.new(
      saving_product_id: saving_product_id,
      depositor_id: depositor_id,
      depositor_type: depositor_type,
      date_opened: date,
      account_number: account_number,
      initial_deposit: amount,
      cooperative: find_employee.cooperative,
      beneficiaries: beneficiaries
    )
    create_accounts(savings_account_application)
    savings_account_application.save!
    create_voucher(savings_account_application)
  end

  def create_accounts(savings_account_application)
    ::AccountCreators::SavingsAccountApplication.new(savings_account_application: savings_account_application).create_accounts!
  end

  def create_voucher(savings_account_application)
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
      commercial_document: savings_account_application
    )
    voucher.voucher_amounts.credit.build(
      cooperative: find_employee.cooperative,
      account: savings_account_application.liability_account,
      amount: amount,
      commercial_document: savings_account_application)
    voucher.save!
  end

  def credit_account
    find_saving_product.account
  end
  def cash_account
    AccountingModule::Account.find(cash_account_id)
  end

  def find_employee
    User.find(employee_id)
  end
  def find_saving_product
    CoopServicesModule::SavingProduct.find(saving_product_id)
  end
  end
