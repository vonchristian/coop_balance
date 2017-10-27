module Vouchers
  class LoanVoucher < Voucher 
    def add_amounts_from(loan)
      loan.charges.each do |charge|
        self.voucher_amounts.create(amount: charge.amount, description: charge.name, account_id: charge.debit_account_id, commercial_document: charge)
      end
    end
  end
end