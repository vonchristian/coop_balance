module LoansModule
	class AmortizationPaymentUpdater
		attr_reader :loan, :schedule, :voucher, :entry

		def initialize(args = {})
			@loan =     args[:loan]
			@schedule = args[:schedule]
			@voucher =  args[:voucher]
			@entry =    @voucher.entry
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
      if voucher.voucher_amounts.credit.where(account: loan.receivable_account).sum(&:amount).to_f >= schedule.principal
        schedule.update(payment_status: "full_payment")
      elsif voucher.voucher_amounts.credit.where(account: loan.receivable_account).sum(&:amount).to_f < schedule.principal
        schedule.update(payment_status: "partial_payment")
      elsif voucher.voucher_amounts.credit.where(account: loan.receivable_account).sum(&:amount).zero?
        schedule.update(payment_status: "unpaid")
      end
    end

    def update_amortization_entry_ids
    	schedule.entry_ids << entry.id
    	schedule.save
    end
  end
end
