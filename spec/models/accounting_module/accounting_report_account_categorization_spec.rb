require 'rails_helper'

module AccountingModule
  describe AccountingReportAccountCategorization, type: :model do
    describe 'associations' do 
      it { is_expected.to belong_to :account_category }
      it { is_expected.to belong_to :accounting_report }
    end 
  end 
end
