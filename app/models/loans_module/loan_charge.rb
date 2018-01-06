module LoansModule
	class LoanCharge < ApplicationRecord
	  has_one :charge_adjustment, dependent: :destroy

	  belongs_to :loan, class_name: "LoansModule::Loan"
	  belongs_to :chargeable, polymorphic: true
	  belongs_to :commercial_document, polymorphic: true

    has_many :loan_charge_payment_schedules, dependent: :destroy

	  validates :loan_id, :chargeable_id, :commercial_document_id, :commercial_document_type, :chargeable_type, presence: true

	  delegate :account, :account_name,  to: :chargeable, allow_nil: true
	  delegate :name, :amount, :regular?, to: :chargeable, allow_nil: true
	  delegate :amortize_balance, to: :charge_adjustment, allow_nil: true

    def interest_on_loan
    	where(chargeable.account == self.loan.interest_on_loan)
    end

	  def self.total
	  	all.sum(&:charge_amount_with_adjustment)
	  end

	  def charge_amount
	  	if chargeable.percent_type?
	  		(chargeable.percent / 100.0) * loan.loan_amount
	  	else
	  		chargeable.amount
		end

	  # def balance
	  # 	if charge_adjustment.present?
	  # 	  charge_amount - charge_adjustment.charge_amount
	  # 	else
	  # 		0
	  # 	end
	  # end

	  def charge_amount_with_adjustment
	  	if charge_adjustment.present?
	  	  charge_adjustment.charge_amount
	    else
	    	charge_amount
	    end
	  end
	end
end
