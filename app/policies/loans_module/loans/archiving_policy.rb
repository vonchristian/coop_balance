module LoansModule
  module Loans
    class ArchivingPolicy
      attr_reader :user, :loan

      def initialize(user, loan)
        @user = user
        @loan = loan
      end

      def new?
        user.loan_officer?
      end

      def create?
        new?
      end
    end
  end
end
