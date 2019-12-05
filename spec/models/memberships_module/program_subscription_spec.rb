require 'rails_helper'

module MembershipsModule
  describe ProgramSubscription do
    context "associations" do
      it { is_expected.to belong_to :program_account }
    	it { is_expected.to belong_to :program }
    	it { is_expected.to belong_to :subscriber }
      it { is_expected.to belong_to :office }
    	it { is_expected.to have_many :subscription_payments }
    end
    describe 'delegations' do
      it { is_expected.to delegate_method(:name).to(:program) }
      it { is_expected.to delegate_method(:description).to(:program) }
    end
  end
end
