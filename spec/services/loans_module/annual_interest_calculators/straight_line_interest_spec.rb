require 'rails_helper'

module LoansModule
  module AnnualInterestCalculators
    describe StraightLineInterest do
      
      it "calculate" do
        expect(described_class.new(term: 2, amount: 2000, rate: 0.025).calculate).to eq 100
        expect(described_class.new(term: 12, amount: 100_000, rate: 0.01).calculate).to eq 12_000
        expect(described_class.new(term: 12, amount: 200_000, rate: 0.01).calculate).to eq 24_000
      end
    end
  end
end
