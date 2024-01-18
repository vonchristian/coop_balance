require 'rails_helper'

describe SavingsAccountApplication do
  describe 'associations' do
    it { should belong_to :cooperative }
    it { should belong_to :office }
    it { should belong_to :depositor }
    it { should belong_to :saving_product }
    it { should belong_to :liability_account }
  end
end
