require 'rails_helper'
module LoansModule
  describe Loan do
    context 'associations' do 
    	it { is_expected.to belong_to :borrower }
    	it { is_expected.to belong_to :loan_product }
      it { is_expected.to have_one :cash_disbursement_voucher }
    	it { is_expected.to have_many :loan_approvals }
    	it { is_expected.to have_many :approvers }
    	it { is_expected.to have_many :entries }
      it { is_expected.to have_many :loan_charges }
      it { is_expected.to have_many :charges }
      it { is_expected.to have_many :loan_additional_charges }
      it { is_expected.to have_many :loan_co_makers }
      it { is_expected.to have_many :co_makers }
      it { is_expected.to have_many :principal_amortization_schedules }
      it { is_expected.to have_many :interest_on_loan_amortization_schedules }
      it { is_expected.to have_many :notices }
    end 

    context 'delegations' do 
    	it { is_expected.to delegate_method(:full_name).to(:borrower).with_prefix }
    	it { is_expected.to delegate_method(:name).to(:loan_product).with_prefix }
    end

    it "#taxable_amount" do 
      loan = create(:loan, loan_amount: 100)

      expect(loan.taxable_amount).to eql(100)
    end
  end
end
