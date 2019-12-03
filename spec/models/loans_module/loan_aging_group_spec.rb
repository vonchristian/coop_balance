require 'rails_helper'

module LoansModule
  describe LoanAgingGroup do
    describe 'attributes' do
      it { is_expected.to respond_to(:title) }
      it { is_expected.to respond_to(:start_num) }
      it { is_expected.to respond_to(:end_num) }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of :title }
      it { is_expected.to validate_presence_of :start_num }
      it { is_expected.to validate_presence_of :end_num }
      it { is_expected.to validate_numericality_of :start_num }
      it { is_expected.to validate_numericality_of :end_num }
    end
  end
end
