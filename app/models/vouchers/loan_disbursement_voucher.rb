module Vouchers
  class LoanDisbursementVoucher < Voucher

    def add_amounts_from(loan)
      self.voucher_amounts.create(amount_type: 'debit', amount: loan.loan_amount, description: 'Loan Amount', account_id: loan.loan_product_account.id, commercial_document: loan)
      self.voucher_amounts.create(amount_type: 'credit', amount: loan.net_proceed, description: 'Net Proceed', account_id: AccountingModule::Account.find_by(name: "Cash on Hand (Teller)").id, commercial_document: loan)
      loan.loan_charges.each do |charge|
        self.voucher_amounts.create(amount_type: 'credit', amount: charge.charge_amount_with_adjustment, description: charge.name, account_id: charge.account.id, commercial_document: charge.commercial_document)
      end
    end
  end
end
