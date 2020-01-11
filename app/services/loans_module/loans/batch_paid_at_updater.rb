module LoansModule
  module Loans 
    class BatchPaidAtUpdater 
      attr_reader :voucher, :office, :date 

      def initialize(voucher:)
        @voucher = voucher 
        @office  = @voucher.office
        @date    = @voucher.date  
      end 

      def loans 
        account_ids = voucher.voucher_amounts.pluck(:account_id)
        loan_ids = [] 
        loan_ids << office.loans.where(receivable_account_id: account_ids).pluck(:id)
        loan_ids << office.loans.where(interest_revenue_account_id: account_ids).pluck(:id)
        loan_ids << office.loans.where(penalty_revenue_account_id: account_ids).pluck(:id)
        
        office.loans.where(id: loan_ids.uniq.compact.flatten)
      end 

      def update_loans!
        loans.each do |loan|
          LoansModule::Loans::PaidAtUpdater.new(loan: loan, date: date).update_paid_at!
        end 
      end 
    end 
  end 
end 