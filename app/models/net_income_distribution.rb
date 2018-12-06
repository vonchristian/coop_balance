class NetIncomeDistribution < ApplicationRecord
  belongs_to :account, class_name: "AccountingModule::Account"
  belongs_to :cooperative

  delegate :name, to: :account, prefix: true
  def amount_for(net_income)
    net_income * rate
  end
  def percent
    rate * 100
  end
end
