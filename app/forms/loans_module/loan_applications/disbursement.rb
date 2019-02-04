module LoansModule
  module LoanApplications
    class Disbursement
      include ActiveModel::Model
      attr_accessor :disbursement_date

      validates :disbursement_date, presence: true 
    end
  end
end
