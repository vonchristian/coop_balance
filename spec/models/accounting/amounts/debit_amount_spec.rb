require 'rails_helper'

module Accounting
  module Amounts
    describe DebitAmount do
      it { is_expected.to monetize(:amount) }

      describe 'associations' do
        it { is_expected.to belong_to(:old_debit_amount).optional }
        it { is_expected.to belong_to :account }
        it { is_expected.to belong_to :entry }
      end
    end
  end
end
