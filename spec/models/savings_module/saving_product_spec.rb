require 'rails_helper'

module SavingsModule
  describe SavingProduct do
    describe "associations" do
      it { is_expected.to belong_to :cooperative }
      it { is_expected.to belong_to :office }

      it { is_expected.to belong_to :closing_account }
      it { is_expected.to have_many :subscribers }
    end

    describe "validations" do
    	it { is_expected.to validate_presence_of :interest_recurrence }
    	it { is_expected.to validate_presence_of :interest_rate }
    	it do
    		is_expected.to validate_numericality_of(:interest_rate).is_greater_than_or_equal_to(0.01)
        is_expected.to validate_numericality_of(:minimum_balance).is_greater_than_or_equal_to(0.01)
    	end
    	it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_uniqueness_of(:name).scoped_to(:office_id) }

    end

    describe 'enums' do
      it { is_expected.to define_enum_for(:interest_recurrence).with([:daily, :weekly, :monthly, :quarterly, :semi_annually, :annually]) }
    end

   
    it "#balance_averager" do
      saving_product = create(:saving_product, interest_recurrence: 'annually')

      expect(saving_product.balance_averager).to eql SavingsModule::BalanceAveragers::Annually
    end

    describe "#applicable_rate" do
      it "annually" do
        saving_product = create(:saving_product, interest_recurrence: 'annually')

        expect(saving_product.applicable_rate).to eql SavingsModule::InterestRateSetters::Annually
      end

      it "semi_annually" do
        saving_product = create(:saving_product, interest_recurrence: 'semi_annually')

        expect(saving_product.applicable_rate).to eql SavingsModule::InterestRateSetters::SemiAnnually
      end

      it "quarterly" do
        saving_product = create(:saving_product, interest_recurrence: 'quarterly')

        expect(saving_product.applicable_rate).to eql SavingsModule::InterestRateSetters::Quarterly
      end
      it "monthly" do
        saving_product = create(:saving_product, interest_recurrence: 'monthly')

        expect(saving_product.applicable_rate).to eql SavingsModule::InterestRateSetters::Monthly
      end

      it "daily" do
        saving_product = create(:saving_product, interest_recurrence: 'daily')

        expect(saving_product.applicable_rate).to eql SavingsModule::InterestRateSetters::Daily
      end
    end

    describe 'date_setter' do
      it "annually" do
        saving_product = create(:saving_product, interest_recurrence: "annually")

        expect(saving_product.date_setter).to eql SavingsModule::DateSetters::Annually
      end

      it "semi_annually" do
        saving_product = create(:saving_product, interest_recurrence: "semi_annually")

        expect(saving_product.date_setter).to eql SavingsModule::DateSetters::SemiAnnually
      end

      it "quarterly" do
        saving_product = create(:saving_product, interest_recurrence: "quarterly")

        expect(saving_product.date_setter).to eql SavingsModule::DateSetters::Quarterly
      end

      it "monthly" do
        saving_product = create(:saving_product, interest_recurrence: "monthly")

        expect(saving_product.date_setter).to eql SavingsModule::DateSetters::Monthly
      end
    end

    

    it ".total_subscribers" do
      saving_product = create(:saving_product)
      subscriber = create(:saving, saving_product: saving_product)
      another_subscriber = create(:saving, saving_product: saving_product)
      expect(described_class.total_subscribers).to eq 2
    end

    it "#total_subscribers" do
      saving_product = create(:saving_product)
      subscriber = create(:saving, saving_product: saving_product)

      expect(saving_product.total_subscribers).to eql 1
    end
  end
end