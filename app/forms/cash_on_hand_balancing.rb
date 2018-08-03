class CashOnHandBalancing
  include ActiveModel::Model
  attr_accessor :employee_id

  def balance
    ActiveRecord::Base.transaction do
      update_cash_on_hand_balance
    end
  end

  private
  def update_cash_on_hand_balance
    voucher_amounts = find_employee.voucher_amounts.where(account: cash_on_hand_account)
    if voucher_amounts.present?
      voucher_amounts.destroy_all
      Vouchers::VoucherAmount.create(
        amount: find_employee.voucher_amounts.sum(&:amount),
        account: cash_on_hand_account,
        amount_type: 'debit',
        description: description,
        commercial_document: find_employee
        )
    end
  end

  def find_employee
    User.find_by_id(employee_id)
  end
  def cash_on_hand_account
    find_employee.cash_on_hand_account
  end
end