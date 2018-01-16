module LoansModule
	class LoanCharge < ApplicationRecord
	  has_one :charge_adjustment, dependent: :destroy

	  belongs_to :loan, class_name: "LoansModule::Loan"
	  belongs_to :chargeable, polymorphic: true
	  belongs_to :commercial_document, polymorphic: true

    has_many :loan_charge_payment_schedules, dependent: :destroy

	  validates :loan_id, :chargeable_id, :commercial_document_id, :commercial_document_type, :chargeable_type, presence: true

	  delegate :account, :account_name, :name, :amount, :regular?, to: :chargeable

		delegate :amortize_balance, to: :charge_adjustment, allow_nil: true
    delegate :adjusted_charge_amount, to: :charge_adjustment
    def interest_on_loan
    	where(chargeable.account == self.loan.interest_on_loan)
    end

	  def self.total
	  	all.sum(&:charge_amount_with_adjustment)
	  end

	  def charge_amount_with_adjustment
	  	if charge_adjustment.present?
	  	  adjusted_charge_amount
	    else
				regular_charge_amount
	    end
	  end

		def regular_charge_amount
			chargeable.amount_for(self.loan)
		end
	end
end
