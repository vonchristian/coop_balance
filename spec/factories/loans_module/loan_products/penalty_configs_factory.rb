FactoryBot.define do
  factory :penalty_config, class: 'LoansModule::LoanProducts::PenaltyConfig' do
    loan_product
    penalty_revenue_account factory: %i[revenue]
    rate { 0.02 }
  end
end
