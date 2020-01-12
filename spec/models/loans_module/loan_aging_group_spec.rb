require 'rails_helper'

module LoansModule
  describe LoanAgingGroup do
    describe 'associations' do
      it { is_expected.to belong_to :office }
      it { is_expected.to have_many :loan_agings }
      it { is_expected.to have_many :loans }
      it { is_expected.to have_many :office_loan_product_aging_groups }
      it { is_expected.to have_many :office_loan_products }
    end

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

    describe 'delegations' do 
      it { is_expected.to delegate_method(:level_one_account_category).to(:current_office_loan_product_aging_group) }
    end 

    it "#num_range" do
      group = create(:loan_aging_group, start_num: 0, end_num: 30)

      expect(group.num_range).to eql 0..30
    end
  end
end
