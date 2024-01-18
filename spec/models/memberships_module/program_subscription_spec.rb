require 'rails_helper'

module MembershipsModule
  describe ProgramSubscription do
    context 'associations' do
      it { should belong_to :program_account }
      it { should belong_to :program }
      it { should belong_to :subscriber }
      it { should belong_to :office }
      it { should have_many :subscription_payments }
    end

    describe 'delegations' do
      it { should delegate_method(:name).to(:program) }
      it { should delegate_method(:description).to(:program) }
    end
  end
end
