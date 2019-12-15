require 'rails_helper'

describe SavingsAccountApplication do
  describe 'associations' do
    it { is_expected.to belong_to :cooperative }
    it { is_expected.to belong_to :office }
    it { is_expected.to belong_to :depositor }
    it { is_expected.to belong_to :saving_product }
    it { is_expected.to belong_to :liability_account }
  end
end
