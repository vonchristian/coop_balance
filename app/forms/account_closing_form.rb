class AccountClosingForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :savings_account_id, :amount, :closing_account_fee, :reference_number, :date, :recorder_id
  validates :amount, presence: true, numericality: true
  validates :reference_number, presence: true
  validate :amount_less_than_current_cash_on_hand?
  validate :amount_is_less_than_balance?

  def save
    if valid?
      ActiveRecord::Base.transaction do
        save_withdraw
      end
    end
  end

  private

  def find_savings_account
    MembershipsModule::Saving.find_by_id(savings_account_id)
  end

  def save_withdraw
    AccountingModule::Entry.create!(
      office: find_employee.office,
      cooperative: find_employee.cooperative,
      recorder: find_employee,
      description: 'Closing of savings account',
      reference_number: reference_number,
      entry_date: date,
      commercial_document: find_savings_account,
      debit_amounts_attributes: [{
        account: debit_account,
        amount: find_savings_account.balance,
        commercial_document: find_savings_account
      }],
      credit_amounts_attributes: [
        {
        account: credit_account,
        amount: amount,
        commercial_document: find_savings_account
        },
        { account: closing_fee_account,
          amount: closing_account_fee,
          commercial_document: find_savings_account
        }
      ])
  end


  def closing_fee_account
    CoopConfigurationsModule::SavingsAccountConfig.default_closing_account
  end

  def credit_account
    find_employee.cash_on_hand_account
  end

  def debit_account
    find_savings_account.saving_product_account
  end

  def find_employee
    User.find_by_id(recorder_id)
  end

  def amount_is_less_than_balance?
    errors[:amount] << "Amount exceeded balance"  if amount.to_f > find_savings_account.balance
  end

  def amount_less_than_current_cash_on_hand?
    errors[:amount] << "Amount exceeded current cash on hand" if amount.to_f > find_employee.cash_on_hand_account_balance
  end
end
