class DisbursementLineItemProcessing
  include ActiveModel::Model
  attr_accessor :amount, :account_id, :description, :amount_type, :employee_id

  def save
    ActiveRecord::Base.transaction do
      create_disbursement_line_item
    end
  end
  private
  def create_disbursement_line_item
    Vouchers::VoucherAmount.create(
      amount: amount,
      account_id: account_id,
      amount_type: amount_type,
      description: description,
      commercial_document: find_employee
      )
  end
  def find_employee
    User.find_by_id(employee_id)
  end
end