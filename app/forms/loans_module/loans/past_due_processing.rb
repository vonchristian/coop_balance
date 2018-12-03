module LoansModule
  module Loans
    class PastDueProcessing
      include ActiveModel::Model
      attr_accessor :date
    end
  end
end 
