module LoansModule
  module Loans
    class UnearnedInterestIncomePostingJob < ApplicationJob
      queue_as :default

      def self.perform(amortization_schedule, employee)
        LoansModule::Loans::UnearnedInterestIncomePosting.new(amortization_schedule, employee).post!
      end
    end
  end
end
