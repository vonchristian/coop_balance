module LoansModule
	class LoanCoMaker < ApplicationRecord
	  belongs_to :loan, class_name: "LoansModule::Loan"
	  belongs_to :co_maker, class_name: "Member", foreign_key: 'co_maker_id'

	  validates :co_maker_id, presence: true
	end
end