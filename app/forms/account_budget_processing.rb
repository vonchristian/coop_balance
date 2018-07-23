class AccountBudgetProcessing
  include ActiveModel::Model
  attr_accessor :account_id, :year, :proposed_amount
  def process!
    ActiveRecord::Base.transaction do
      create_account_budget
    end
  end

  private
  def create_account_budget
    AccountBudget.create(
      account_id: account_id,
      year: year,
      proposed_amount: proposed_amount)
  end
end
