require 'rails_helper'
module TimeDepositsModule
  describe TimeDepositApplication do
    describe 'associations' do
      it { should belong_to :cooperative }
      it { should belong_to :office }
      it { should belong_to :depositor }
      it { should belong_to :time_deposit_product }
      it { should belong_to :liability_account }
    end

    describe 'validations' do
      it { should validate_presence_of :number_of_days }
      it { should validate_numericality_of :number_of_days }
    end
  end
end