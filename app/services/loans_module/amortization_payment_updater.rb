module LoansModule
	class AmortizationPaymentUpdater
		attr_reader :loan, :schedule, :voucher, :entry

		def initialize(args = {})
			@loan =     args[:loan]
			@schedule = args[:schedule]
			@voucher =  args[:voucher]
			@entry =    args[:entry]
		end

		def update_status!
			if @schedule.present?
				ActiveRecord::Base.transaction do
	        update_amortization_payment_status
	        update_amortization_entry_ids
	      end
      end
		end

    def update_amortization_payment_status
      if voucher.voucher_amounts.credit.where(account: loan.loan_product_current_account).last.amount.to_f < schedule.principal
        schedule.update(payment_status: "partial_payment")
      else
        schedule.update(payment_status: "full_payment")
      end
    end

    def update_amortization_entry_ids
    	schedule.entry_ids << entry.id
    	schedule.save
    end
  end
end

