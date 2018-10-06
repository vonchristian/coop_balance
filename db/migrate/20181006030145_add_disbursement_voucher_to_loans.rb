class AddDisbursementVoucherToLoans < ActiveRecord::Migration[5.2]
  def change
    add_reference :loans, :disbursement_voucher, foreign_key: { to_table: :vouchers }, type: :uuid
  end
end
