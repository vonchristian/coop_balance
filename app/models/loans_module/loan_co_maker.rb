module LoansModule
  class LoanCoMaker < ApplicationRecord
    belongs_to :loan, class_name: "LoansModule::Loan"
    belongs_to :co_maker, polymorphic: true

    validates :co_maker_id, uniqueness: { scope: :loan_id }
    delegate :avatar, :name, to: :co_maker
  end
end
