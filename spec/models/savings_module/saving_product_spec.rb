require 'rails_helper'

module SavingsModule
  describe SavingProduct do
    describe 'associations' do
      it { should belong_to :cooperative }
      it { should belong_to :office }

      it { should belong_to :closing_account }
      it { should have_many :subscribers }
    end

    describe 'validations' do
      it { should validate_presence_of :interest_recurrence }
      it { should validate_presence_of :interest_rate }

      it do
        expect(subject).to validate_numericality_of(:interest_rate).is_greater_than_or_equal_to(0.01)
        expect(subject).to validate_numericality_of(:minimum_balance).is_greater_than_or_equal_to(0.01)
      end

      it { should validate_presence_of :name }
      it { should validate_uniqueness_of(:name).scoped_to(:office_id) }
    end

    describe 'enums' do
      it { should define_enum_for(:interest_recurrence).with(%i[daily weekly monthly quarterly semi_annually annually]) }
    end

    it '#balance_averager' do
      saving_product = create(:saving_product, interest_recurrence: 'annually')

      expect(saving_product.balance_averager).to eql SavingsModule::BalanceAveragers::Annually
    end

    describe '#applicable_rate' do
      it 'annually' do
        saving_product = create(:saving_product, interest_recurrence: 'annually')

        expect(saving_product.applicable_rate).to eql SavingsModule::InterestRateSetters::Annually
      end

      it 'semi_annually' do
        saving_product = create(:saving_product, interest_recurrence: 'semi_annually')

        expect(saving_product.applicable_rate).to eql SavingsModule::InterestRateSetters::SemiAnnually
      end

      it 'quarterly' do
        saving_product = create(:saving_product, interest_recurrence: 'quarterly')

        expect(saving_product.applicable_rate).to eql SavingsModule::InterestRateSetters::Quarterly
      end

      it 'monthly' do
        saving_product = create(:saving_product, interest_recurrence: 'monthly')

        expect(saving_product.applicable_rate).to eql SavingsModule::InterestRateSetters::Monthly
      end

      it 'daily' do
        saving_product = create(:saving_product, interest_recurrence: 'daily')

        expect(saving_product.applicable_rate).to eql SavingsModule::InterestRateSetters::Daily
      end
    end

    describe 'date_setter' do
      it 'annually' do
        saving_product = create(:saving_product, interest_recurrence: 'annually')

        expect(saving_product.date_setter).to eql SavingsModule::DateSetters::Annually
      end

      it 'semi_annually' do
        saving_product = create(:saving_product, interest_recurrence: 'semi_annually')

        expect(saving_product.date_setter).to eql SavingsModule::DateSetters::SemiAnnually
      end

      it 'quarterly' do
        saving_product = create(:saving_product, interest_recurrence: 'quarterly')

        expect(saving_product.date_setter).to eql SavingsModule::DateSetters::Quarterly
      end

      it 'monthly' do
        saving_product = create(:saving_product, interest_recurrence: 'monthly')

        expect(saving_product.date_setter).to eql SavingsModule::DateSetters::Monthly
      end
    end

    it '.total_subscribers' do
      saving_product = create(:saving_product)
      create(:saving, saving_product: saving_product)
      create(:saving, saving_product: saving_product)
      expect(described_class.total_subscribers).to eq 2
    end

    it '#total_subscribers' do
      saving_product = create(:saving_product)
      create(:saving, saving_product: saving_product)

      expect(saving_product.total_subscribers).to be 1
    end
  end
end
