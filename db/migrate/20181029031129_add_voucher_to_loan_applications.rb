class AddVoucherToLoanApplications < ActiveRecord::Migration[5.2]
  def change
    add_reference :loan_applications, :voucher, foreign_key: true, type: :uuid
  end
end
