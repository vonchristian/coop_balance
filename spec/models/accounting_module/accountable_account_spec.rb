require 'rails_helper'

module AccountingModule
  describe AccountableAccount do
    describe 'associations' do
      it { should belong_to :accountable }
      it { should belong_to :account }
    end
  end
end
