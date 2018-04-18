module Vouchers
  class LoanDisbursementVoucher < Voucher
    def add_amounts_from(loan)
      self.voucher_amounts.create!(
      amount_type: 'debit',
      amount: loan.loan_amount,
      description: 'Loan Amount',
      account: loan.loan_product_loans_receivable_current_account,
      commercial_document: loan)

      self.voucher_amounts.create!(
      amount_type: 'credit',
      amount: loan.net_proceed,
      description: 'Net Proceed',
      account: AccountingModule::Account.find_by(name: "Cash on Hand"),
      commercial_document: loan)

      loan.loan_charges.credit.each do |charge|
        self.voucher_amounts.create!(
        amount_type: 'credit',
        amount: charge.charge_amount_with_adjustment,
        description: charge.name,
        account: charge.account,
        commercial_document: charge.commercial_document)
      end

      loan.loan_charges.debit.each do |charge|
        self.voucher_amounts.create!(
        amount_type: 'debit',
        amount: charge.charge_amount_with_adjustment,
        description: charge.name,
        account: charge.account,
        commercial_document: charge.commercial_document)
      end
    end
  end
end
