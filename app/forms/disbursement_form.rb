class DisbursementForm
  include ActiveModel::Model
  attr_accessor  :voucher_id, :voucherable_id, :amount, :reference_number, :date, :recorder_id, :description, :total_amount
  validates :reference_number, presence: true
  # validate :amount_less_than_current_cash_on_hand?

  def save
    ActiveRecord::Base.transaction do
      save_cash_disbursement
      disburse_voucher
    end
  end
  def save_cash_disbursement
    entry = AccountingModule::Entry.new(
      commercial_document: find_voucher,
      :description => description,
      recorder: find_employee,
      origin: find_employee.office,
      entry_date: date)
    find_voucher.voucher_amounts.debit.each do |amount|
      debit_amount = AccountingModule::DebitAmount.new(
        account_id: amount.account_id,
        amount: amount.amount,
        commercial_document: amount.commercial_document)
      entry.debit_amounts << debit_amount
    end
    find_voucher.voucher_amounts.credit.each do |amount|
      credit_amount = AccountingModule::CreditAmount.new(
        account: credit_account_for(amount),
        amount: amount.amount,
        commercial_document: amount.commercial_document)
      entry.credit_amounts << credit_amount
    end
    entry.save!
  end

  def credit_account_for(amount)
    if amount.account.name.downcase.include?("cash") || amount.account.name.downcase.include?("Cash")
      find_employee.cash_on_hand_account
    else
      amount.account
    end
  end
  def disburse_voucher
    find_voucher.update_attributes(disburser: find_employee)
    if find_voucher.payee.kind_of?(LoansModule::Loan)
      update_loan
    end
  end
  def update_loan
    payee.update_attributes(disbursement_date: date)
    LoansModule::AmortizationSchedule.create_schedule_for(payee)
    payee.current_term.update_attributes(effectivity_date: date, maturity_date: maturity_date)
  end

  def maturity_date
    date.to_date + payee.current_term_number_of_months.to_i.months
  end

  def find_voucher
    Voucher.find_by_id(voucher_id)
  end
  def payee
    find_voucher.payee
  end

  def find_employee
    User.find_by(id: recorder_id)
  end
  private
  def amount_less_than_current_cash_on_hand?
    errors[:total_amount] << "Amount exceeded current cash on hand" if BigDecimal.new(total_amount) > find_employee.cash_on_hand_account_balance
  end
end
