module LoansModule
  module Loans
    class LossProcessing
      include ActiveModel::Model
      attr_accessor :loan_id
    end
  end
end
