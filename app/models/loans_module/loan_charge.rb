module LoansModule
	class LoanCharge < ApplicationRecord
	  has_one :charge_adjustment, dependent: :destroy

	  belongs_to :loan, class_name: "LoansModule::Loan"
	  belongs_to :chargeable, polymorphic: true
	  belongs_to :commercial_document, polymorphic: true

    has_many :loan_charge_payment_schedules, dependent: :destroy

	  validates :loan_id, :chargeable_id, :commercial_document_id, :commercial_document_type, :chargeable_type, presence: true

	  delegate :account, :account_name, :name, :amount, :regular?, to: :chargeable

		delegate :amortize_balance?, :amortizeable_amount, to: :charge_adjustment, allow_nil: true

	  def self.total
	  	all.map{|a| a.charge_amount_with_adjustment }.compact.sum
	  end

	  def charge_amount_with_adjustment
	  	if charge_adjustment.present?
	  	  adjusted_amount
	    else
				regular_charge_amount
	    end
	  end
	  def adjusted_amount
	  	charge_adjustment.adjusted_charge_amount
	  end

		def regular_charge_amount
			chargeable.amount_for(self.loan)
		end
		def number_of_interest_payments_prededucted
      if charge_adjustment.present? && charge_adjustment.number_of_payments.present?
        charge_adjustment.number_of_payments
      else
        0
      end
    end
	end
end
