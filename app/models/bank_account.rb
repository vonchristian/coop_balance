class BankAccount < ApplicationRecord
  enum entry_type: [:bank_deposit, :bank_withdrawal, :bank_earned_interest, :bank_charge]
  belongs_to :cooperative
  validates :bank_name, :bank_address, :account_number, presence: true
  has_many :entries, class_name: "AccountingModule::Entry", as: :commercial_document, dependent: :destroy
  def balance_total 
    deposits_total + earned_interests_total - withdrawals_total - bank_expenses_total
  end
  def deposits_total
    entries.bank_deposit.map{|a| a.debit_amounts.distinct.sum(:amount) }.sum
  end
  def withdrawals_total
    entries.bank_withdrawal.map{|a| a.debit_amounts.distinct.sum(:amount) }.sum 
  end

  def earned_interests_total
    entries.bank_earned_interest.map{|a| a.debit_amounts.distinct.sum(:amount) }.sum 
  end
  def bank_expenses_total
    entries.bank_charge.map{|a| a.debit_amounts.distinct.sum(:amount) }.sum 
  end
end
