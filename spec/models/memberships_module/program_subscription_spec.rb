require 'rails_helper'

module MembershipsModule
  describe ProgramSubscription do
    context "associations" do
    	it { is_expected.to belong_to :program }
    	it { is_expected.to belong_to :subscriber }
    	it { is_expected.to have_many :subscription_payments }
    end
    describe 'delegations' do
      it { is_expected.to delegate_method(:name).to(:program) }
      it { is_expected.to delegate_method(:contribution).to(:program) }
      it { is_expected.to delegate_method(:description).to(:program) }
    end
    it "#paid?(from_date, to_date)" do
      program_subscription = create(:program_subscription)
      entry = create(:entry_with_credit_and_debit, entry_date: Date.today, commercial_document: program_subscription, entry_type: 'program_subscription_payment')
      expect(program_subscription.subscription_payments).to be_present
      expect(program_subscription.paid?(Date.today.beginning_of_year, Date.today.end_of_year)).to be true
    end
  end
end
