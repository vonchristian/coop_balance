require 'rails_helper'

module AccountingModule
  describe AccountableAccount do
    describe 'associations' do
      it { is_expected.to belong_to :accountable }
      it { is_expected.to belong_to :account }
    end
  end
end
