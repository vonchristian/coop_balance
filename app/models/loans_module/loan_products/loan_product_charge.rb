module LoansModule
  module LoanProducts
    class LoanProductCharge < ApplicationRecord
      belongs_to :charge
      belongs_to :loan_product, class_name: "LoansModule::LoanProduct"
      delegate :name, :amount, to: :charge

      accepts_nested_attributes_for :charge
    end
  end
end