require 'rails_helper'

module Accounting
  module Amounts
    describe CreditAmount do
      it { is_expected.to monetize(:amount) }

      describe 'associations' do
        it { is_expected.to belong_to(:old_credit_amount).optional }
        it { is_expected.to belong_to :account }
        it { is_expected.to belong_to :entry }
      end
    end
  end
end
