FactoryBot.define do
  factory :cooperative_banking_agent, class: Cooperatives::CooperativeBankingAgent do
    association :cooperative
    association :banking_agent
  end
end
