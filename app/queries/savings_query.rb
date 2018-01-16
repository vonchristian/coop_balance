class SavingsQuery
  attr_reader :relation
  def initialize(relation = MembershipsModule::Saving.all)
    @relation = relation
  end

  def has_minimum_balance
    relation.select{|a| a.balance >= a.saving_product.minimum_balance }
  end

  def below_minimum_balance
    relation.select{|a| a.balance < a.saving_product.minimum_balance }
  end

  def dormant_accounts(days_count)
    relation.select { |a| a.number_of_days_inactive >= days_count }
  end
end

