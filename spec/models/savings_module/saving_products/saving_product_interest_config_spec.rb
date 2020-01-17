require 'rails_helper'

module SavingsModule 
  module SavingProducts 
    describe SavingProductInterestConfig do
      describe 'associations' do 
        it { is_expected.to belong_to :interest_expense_category }
        it { is_expected.to belong_to :saving_product }
      end 

      describe 'validations' do 
        it { is_expected.to validate_presence_of :annual_rate }
        it { is_expected.to validate_numericality_of :annual_rate }
      end 

      it { is_expected.to define_enum_for(:interest_posting).with_values([:annually])}


      it "#balance_averager" do 
        annually = create(:saving_product_interest_config, interest_posting: 'annually')

        expect(annually.balance_averager).to eq SavingsModule::BalanceAveragers::Annually
      end 

      it "#date_setter" do 
        annually = create(:saving_product_interest_config, interest_posting: 'annually')

        expect(annually.date_setter).to eq SavingsModule::DateSetters::Annually
      end
      
      it "#interest_rate_setter" do 
        annually = create(:saving_product_interest_config, interest_posting: 'annually')

        expect(annually.interest_rate_setter).to eq SavingsModule::InterestRateSetters::Annually
      end
    end 
  end 
end
