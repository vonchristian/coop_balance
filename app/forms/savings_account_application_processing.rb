class SavingsAccountApplicationProcessing
  include ActiveModel::Model
  attr_accessor :saving_product_id, :depositor_id, :depositor_type,
  :cash_account_id, :reference_number, :date, :amount, :description,
  :employee_id, :voucher_account_number, :account_number

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
    savings_account_application = SavingsAccountApplication.create!(
      saving_product_id: saving_product_id,
      depositor_id: depositor_id,
      depositor_type: depositor_type,
      date_opened: date,
      account_number: account_number,
      initial_deposit: amount
    )
    create_voucher(savings_account_application)
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
      number: reference_number,
      date: date
    )
    voucher.voucher_amounts.debit.build(
      account: cash_account,
      amount: amount,
      commercial_document: savings_account_application
    )
    voucher.voucher_amounts.credit.build(
      account: credit_account,
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