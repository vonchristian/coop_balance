module LoansModule
  module Loans
    class Restructuring
      include ActiveModel::Model
      attr_accessor :date_restructured, :notes, :loan_amount
    end
  end
end
