module Vouchers
  class LoanDisbursementVoucher < Voucher
   def self.disbursed_on(hash={})
      if hash[:from_date] && hash[:to_date]
       from_date = hash[:from_date].kind_of?(DateTime) ? hash[:from_date] : Chronic.parse(hash[:from_date].strftime('%Y-%m-%d 12:00:00'))
        to_date = hash[:to_date].kind_of?(DateTime) ? hash[:to_date] : Chronic.parse(hash[:to_date].strftime('%Y-%m-%d 12:59:59'))
        where('date' => (from_date.beginning_of_day)..(to_date.end_of_day))
      else
        all
      end
    end
    def add_amounts_from(loan)
      self.voucher_amounts.create(amount_type: 'debit', amount: loan.loan_amount, description: 'Loan Amount', account_id: loan.loan_product_account.id, commercial_document: loan)
      self.voucher_amounts.create(amount_type: 'credit', amount: loan.net_proceed, description: 'Net Proceed', account_id: AccountingModule::Account.find_by(name: "Cash on Hand (Teller)").id, commercial_document: loan)
      loan.charges.each do |charge|
        self.voucher_amounts.create(amount_type: 'credit', amount: charge.amount, description: charge.name, account_id: charge.account_id, commercial_document: charge)
      end
    end
  end
end
