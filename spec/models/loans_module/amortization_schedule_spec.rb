require 'rails_helper'

module LoansModule
  describe AmortizationSchedule do
    describe 'associations' do
      it { should have_many :payment_notices }
      it { should belong_to(:loan).optional }
      it { should belong_to(:loan_application).optional }
      it { should belong_to :office }
      it { should have_many :notes }
    end

    describe 'validations' do
      it { should validate_presence_of :principal }
      it { should validate_presence_of :interest }
      it { should validate_numericality_of(:principal) }
      it { should validate_numericality_of(:interest) }
    end

    describe 'delegations' do
      it { should delegate_method(:borrower).to(:loan) }
      it { should delegate_method(:loan_product_name).to(:loan) }
      it { should delegate_method(:name).to(:borrower).with_prefix }
      it { should delegate_method(:current_contact_number).to(:borrower).with_prefix }
      it { should delegate_method(:current_address_complete_address).to(:borrower).with_prefix }
    end

    it '.latest' do
      old = create(:amortization_schedule, date: Date.current.last_month)
      latest = create(:amortization_schedule, date: Date.current)

      expect(described_class.latest).to eql latest
      expect(described_class.latest).not_to eql old
    end

    it '.oldest' do
      old = create(:amortization_schedule, date: Date.current.last_month)
      latest = create(:amortization_schedule, date: Date.current)

      expect(described_class.oldest).to eql old
      expect(described_class.oldest).not_to eql latest
    end

    describe '.total_principal' do
      it 'with no dates' do
        create(:amortization_schedule, principal: 500)
        create(:amortization_schedule, principal: 500)

        expect(described_class.total_principal).to be 1_000
      end

      it 'with dates' do
        create(:amortization_schedule, principal: 500, date: Date.current)
        create(:amortization_schedule, principal: 500, date: Date.current.last_month)

        expect(described_class.total_principal(from_date: Date.current, to_date: Date.current)).to be 500
        expect(described_class.total_principal(from_date: Date.current.last_month, to_date: Date.current.last_month)).to be 500
      end
    end

    it '#total_interests' do
      create(:amortization_schedule, interest: 500, date: Date.current)
      create(:amortization_schedule, interest: 500, date: Date.current.last_month)

      expect(described_class.total_interest).to be 1000
    end

    it '.scheduled_for(args={})' do
      amortization_1 = create(:amortization_schedule, date: Date.current)
      amortization_2 = create(:amortization_schedule, date: Date.current.last_month)

      expect(described_class.scheduled_for(from_date: Date.current, to_date: Date.current)).to include(amortization_1)
      expect(described_class.scheduled_for(from_date: Date.current, to_date: Date.current)).not_to include(amortization_2)
    end

    it '#total_amortization' do
      amortization = build(:amortization_schedule, interest: 100, principal: 1_000)

      expect(amortization.total_amortization).to be 1_100
    end

    it '#previous_schedule' do
      amortization        = create(:amortization_schedule, date: Date.current)
      prev_amortization   = create(:amortization_schedule, date: Date.yesterday)
      latest_amortization = create(:amortization_schedule, date: Date.current.next_month)

      expect(amortization.previous_schedule).to eql prev_amortization
      expect(amortization.previous_schedule).not_to eql latest_amortization
    end
  end
end
