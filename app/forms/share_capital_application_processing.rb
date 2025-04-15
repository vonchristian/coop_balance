class ShareCapitalApplicationProcessing
  include ActiveModel::Model
  attr_accessor :subscriber_id, :subscriber_type, :share_capital_product_id,
                :date_opened, :amount, :reference_number, :description, :employee_id, :account_number,
                :cash_account_id, :voucher_account_number, :beneficiaries

  validates :subscriber_id, :subscriber_type, :share_capital_product_id,
            :date_opened, :amount, :reference_number, :description, :employee_id, :account_number,
            :cash_account_id, :voucher_account_number, presence: true
  def process!
    return unless valid?

    ActiveRecord::Base.transaction do
      create_share_capital_application
    end
  end

  def find_share_capital_application
    find_office.share_capital_applications.find_by(account_number: account_number)
  end

  def find_voucher
    TreasuryModule::Voucher.find_by(account_number: voucher_account_number)
  end

  private

  def create_share_capital_application
    share_capital_application = find_office.share_capital_applications.build(
      share_capital_product_id: share_capital_product_id,
      subscriber_id: subscriber_id,
      subscriber_type: subscriber_type,
      date_opened: date_opened,
      account_number: account_number,
      initial_capital: amount,
      cooperative: find_employee.cooperative,
      office: find_employee.office,
      beneficiaries: beneficiaries
    )
    create_accounts(share_capital_application)
    share_capital_application.save!
    create_voucher(share_capital_application)
  end

  def create_accounts(share_capital_application)
    ::AccountCreators::ShareCapitalApplication.new(share_capital_application: share_capital_application).create_accounts!
  end

  def create_voucher(share_capital_application)
    voucher = TreasuryModule::Voucher.new(
      account_number: voucher_account_number,
      payee_id: subscriber_id,
      payee_type: subscriber_type,
      preparer: find_employee,
      office: find_employee.office,
      cooperative: find_employee.cooperative,
      description: description,
      reference_number: reference_number,
      date: date_opened
    )
    voucher.voucher_amounts.debit.build(
      cooperative: find_employee.cooperative,
      account: cash_account,
      amount: amount
    )

    voucher.voucher_amounts.credit.build(
      cooperative: find_employee.cooperative,
      account: share_capital_application.equity_account,
      amount: amount
    )

    voucher.save!
  end

  def cash_account
    find_employee.cash_accounts.find(cash_account_id)
  end

  def find_employee
    User.find(employee_id)
  end

  def find_office
    find_employee.office
  end
end
