require 'rails_helper'

module SavingsModule
  describe SavingsAccountAging do
    describe 'associations' do 
      it { is_expected.to belong_to :savings_account }
      it { is_expected.to belong_to :savings_aging_group }
    end 
  end 
end
