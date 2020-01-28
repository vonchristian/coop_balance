require 'rails_helper'

module LoansModule
  describe LoanCoMaker do
    describe 'associations' do
      it { is_expected.to belong_to :loan }
      it { is_expected.to belong_to :co_maker }
    end
    describe 'validations' do
      it 'validate_uniqueness_of(:co_maker_id).scoped_to(:loan_id)' do 
        loan = create(:loan)
        co_maker = create(:member)
        create(:loan_co_maker, loan: loan, co_maker: co_maker)
        loan_co_maker = build(:loan_co_maker, loan: loan, co_maker: co_maker)

        loan_co_maker.save 

        expect(loan_co_maker.errors[:co_maker_id]).to eq ['has already been taken']
      end 

    end
    describe 'delegations' do
      it { is_expected.to delegate_method(:avatar).to(:co_maker) }
      it { is_expected.to delegate_method(:name).to(:co_maker) }
    end
  end
end
