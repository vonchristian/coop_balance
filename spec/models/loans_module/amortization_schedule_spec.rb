require 'rails_helper'

module LoansModule
  describe AmortizationSchedule do
    describe 'associations' do
      it { is_expected.to have_many :payment_notices }
    	it { is_expected.to belong_to :loan }
      it { is_expected.to belong_to :loan_application }
      it { is_expected.to belong_to :cooperative }
      it { is_expected.to belong_to :office }
      it { is_expected.to have_many :notes }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of :principal }
      it { is_expected.to validate_presence_of :interest }
      it { is_expected.to validate_numericality_of(:principal) }
      it { is_expected.to validate_numericality_of(:interest) }
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:borrower).to(:loan) }
      it { is_expected.to delegate_method(:loan_product_name).to(:loan) }
      it { is_expected.to delegate_method(:name).to(:borrower).with_prefix }
      it { is_expected.to delegate_method(:current_contact_number).to(:borrower).with_prefix }
      it { is_expected.to delegate_method(:current_address_complete_address).to(:borrower).with_prefix }
    end

    it '.latest' do
      old = create(:amortization_schedule, date: Date.current.last_month)
      latest = create(:amortization_schedule, date: Date.current)

      expect(described_class.latest).to eql latest
      expect(described_class.latest).to_not eql old
    end

    it '.oldest' do
      old = create(:amortization_schedule, date: Date.current.last_month)
      latest = create(:amortization_schedule, date: Date.current)

      expect(described_class.oldest).to eql old
      expect(described_class.oldest).to_not eql latest
    end

    describe '.total_principal' do
      it 'with no dates' do
        amortization_1 = create(:amortization_schedule, principal: 500)
        amortization_2 = create(:amortization_schedule, principal: 500)

        expect(described_class.total_principal).to eql 1_000
      end

      it 'with dates' do
        amortization_1 = create(:amortization_schedule, principal: 500, date: Date.current)
        amortization_2 = create(:amortization_schedule, principal: 500, date: Date.current.last_month)

        expect(described_class.total_principal(from_date: Date.current, to_date: Date.current)).to eql 500
        expect(described_class.total_principal(from_date: Date.current.last_month, to_date: Date.current.last_month)).to eql 500

      end
    end

    describe '.total_interest(args={})' do
      it "with no dates" do
        amortization_1 = create(:amortization_schedule, interest: 500)
        amortization_2 = create(:amortization_schedule, interest: 500)

        expect(described_class.total_interest).to eql 1_000
      end
      it '#with dates' do
        amortization_1 = create(:amortization_schedule, interest: 500, date: Date.current)
        amortization_2 = create(:amortization_schedule, interest: 500, date: Date.current.last_month)

        expect(described_class.total_interest(from_date: Date.current, to_date: Date.current)).to eql 500
        expect(described_class.total_interest(from_date: Date.current.last_month, to_date: Date.current.last_month)).to eql 500
      end
    end

    it ".scheduled_for(args={})" do
      amortization_1 = create(:amortization_schedule, date: Date.current)
      amortization_2 = create(:amortization_schedule, date: Date.current.last_month)

      expect(described_class.scheduled_for(from_date: Date.current, to_date: Date.current)).to include(amortization_1)
      expect(described_class.scheduled_for(from_date: Date.current, to_date: Date.current)).to_not include(amortization_2)

    end

    it "#total_amortization" do
      amortization = build(:amortization_schedule, interest: 100, principal: 1_000)

      expect(amortization.total_amortization).to eql 1_100
    end

    it "#previous_schedule" do
      amortization        = create(:amortization_schedule, date: Date.current)
      prev_amortization   = create(:amortization_schedule, date: Date.yesterday)
      latest_amortization = create(:amortization_schedule, date: Date.current.next_month)

      expect(amortization.previous_schedule).to eql prev_amortization
      expect(amortization.previous_schedule).to_not eql latest_amortization
    end

  end
end
