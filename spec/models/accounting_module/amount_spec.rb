require 'rails_helper'
module AccountingModule
  RSpec.describe Amount, type: :model do
    subject { build(:amount) }
    it { is_expected.to_not be_valid }

    describe 'associations' do
      it { is_expected.to belong_to :entry }
      it { is_expected.to belong_to :account }
      it { is_expected.to belong_to :commercial_document }
      it { is_expected.to belong_to :recorder }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of     :type }
      it { is_expected.to validate_presence_of     :account }
      it { is_expected.to validate_presence_of     :entry }
      it { is_expected.to validate_presence_of     :amount }
      it { is_expected.to validate_presence_of     :commercial_document_id }
      it { is_expected.to validate_numericality_of :amount }
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:name).to(:account).with_prefix }
      it { is_expected.to delegate_method(:entry_date).to(:entry) }
      it { is_expected.to delegate_method(:recorder).to(:entry) }
      it { is_expected.to delegate_method(:reference_number).to(:entry) }
      it { is_expected.to delegate_method(:description).to(:entry) }
    end
  end
end
