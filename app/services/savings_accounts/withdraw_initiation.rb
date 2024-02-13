# frozen_string_literal: true

class SavingsAccounts::WithdrawInitiation < ActiveInteraction::Base
  object :savings_account, class: 'DepositsModule::Saving'
  object :employee, class: 'User'

  uuid :account_number, :cash_account_id
  decimal :amount
  string :or_number, :account_number, :description
  date_time :date
  boolean :offline_receipt, default: true
  validates :amount, presence: true, numericality: { greater_than: 0.01 }
  validates :or_number, :date, :description, :cash_account_id, presence: true

  validate :amount_exceed_balance?

  def execute
    voucher = build_voucher
    build_debit_amounts(voucher)
    build_credit_amounts(voucher)

    voucher.save!
    voucher
  end

  private

  def build_voucher
    Voucher.new(
      payee: savings_account.depositor,
      office: employee.office,
      cooperative: employee.cooperative,
      preparer: employee,
      description: description,
      reference_number: or_number,
      account_number: account_number,
      date: date
    )
  end

  def build_debit_amounts(voucher)
    voucher.voucher_amounts.debit.build(
      cooperative: employee.cooperative,
      account_id: savings_account.liability_account_id,
      amount: amount
    )
  end

  def build_credit_amounts(voucher)
    voucher.voucher_amounts.credit.build(
      cooperative: employee.cooperative,
      account_id: cash_account_id,
      amount: amount
    )
  end

  def amount_exceed_balance?
    errors.add(:base, 'Exceeded available balance') if amount.to_f > savings_account.balance
  end
end

