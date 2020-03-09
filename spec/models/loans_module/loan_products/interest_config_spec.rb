require 'rails_helper'

module LoansModule
  module LoanProducts
    describe InterestConfig do
      it { is_expected.to define_enum_for(:calculation_type).with_values([:add_on, :prededucted])}

      describe 'associations' do
        it { is_expected.to belong_to :loan_product }
      end

      describe "validations" do
        it { is_expected.to validate_presence_of :rate }
        it { is_expected.to validate_numericality_of :rate }
      end

     
     
      it "#compute_interest" do
        interest_config = create(:interest_config, rate: 0.12)
        interest_config_2 = create(:interest_config, rate: 0.17)

        expect(interest_config.compute_interest(amount: 100_000, number_of_days: 365)).to eq 12_000
        expect(interest_config_2.compute_interest(amount: 100_000, number_of_days: 365).to_f).to eq 17_000.0
      end

      it "#monthly_interest_rate" do
        interest_config = build_stubbed(:interest_config, rate: 0.12)

        expect(interest_config.monthly_interest_rate).to eql 0.01
      end

      it "#applicable_term" do
        expect(described_class.new.applicable_term(365)).to eql 12
        expect(described_class.new.applicable_term(45)).to eql 1.5
        expect(described_class.new.applicable_term(29)).to eql 1
        expect(described_class.new.applicable_term(30)).to eq 1



      end
    end
  end
end
