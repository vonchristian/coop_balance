class AddLoanApplicationToVoucherAmounts < ActiveRecord::Migration[5.2]
  def change
    add_reference :voucher_amounts, :loan_application, foreign_key: true, type: :uuid
  end
end
