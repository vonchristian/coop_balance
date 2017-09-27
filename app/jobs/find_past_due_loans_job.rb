class FindPastDueLoansJob < ApplicationJob
  queue_as :default
  def self.perform(loans)
  end 
end 