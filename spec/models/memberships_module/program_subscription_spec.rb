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
      subscriber = create(:member)
      program = create(:program, payment_schedule_type: "annually")
      program_subscription = create(:program_subscription, program: program, subscriber: subscriber)
      date = Date.today
      entry = build(:entry, commercial_document: program_subscription, entry_date: date)
      create(:debit_amount, entry: entry, commercial_document: program_subscription, account: program.account)
      create(:credit_amount, entry: entry, commercial_document: subscriber, account: program.account)
      entry.save
      expect(program_subscription.paid?(from_date: Date.today.beginning_of_year, to_date: Date.today.end_of_year)).to be true
    end
  end
end
