class SavingsQuery
  attr_reader :relation
  def initialize(relation = MembershipsModule::Saving.all)
    @relation = relation
  end

  def has_minimum_balance
    relation.select{|a| a.balance >= a.saving_product.minimum_balance }
  end

  def below_minimum_balance
    accounts = []
    relation.find_in_batches.each do |accounts|
      accounts.each do |account|
        if account.balance < account.saving_product.minimum_balance
          accounts << account
        end
      end
      accounts
    end
  end

  def dormant_accounts(days_count = CoopConfigurationsModule::SavingsAccountConfig.default_number_of_days_to_be_dormant)
    relation.select { |a| a.number_of_days_inactive >= days_count }
  end
end
