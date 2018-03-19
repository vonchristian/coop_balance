module LoansModule
	class LoanCoMaker < ApplicationRecord
	  belongs_to :loan, class_name: "LoansModule::Loan"
	  belongs_to :co_maker, polymorphic: true

	  validates :co_maker_id, presence: true
    validates :co_maker_id, uniqueness: { scope: :loan_id }

    delegate :current_occupation, to: :co_maker, allow_nil: true
	end
end
