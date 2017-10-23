module LoansModule
  class Collateral < ApplicationRecord
    belongs_to :loan, class_name: "LoansModule::Loan"
    belongs_to :real_property
  end
end
