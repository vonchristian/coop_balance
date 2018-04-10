module LoansModule
  module Loans
    class LossProcessing
      include ActiveModel::Model
      attr_accessor :loan_id, :date, :description, :reference_number
    end
  end
end
