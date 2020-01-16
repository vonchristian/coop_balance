require 'rails_helper'

module Offices 
  describe NetIncomeConfig, type: :model do
    describe 'associations' do 
      it { is_expected.to belong_to :office }
      it { is_expected.to belong_to :net_income_account }
    end 

    it { is_expected.to define_enum_for(:book_closing).with_values([:annually, :semi_annually, :quarterly, :monthly]) }

    it '.current' do 
      old_config = create(:net_income_config, created_at: Date.current.last_year)
      new_config = create(:net_income_config, created_at: Date.current)

      expect(described_class.current).to eq new_config
      expect(described_class.current).to_not eq old_config
    end

    it '#date_setter' do 
      annually      = create(:net_income_config, book_closing: 'annually')
      semi_annually = create(:net_income_config, book_closing: 'semi_annually')
      quarterly     = create(:net_income_config, book_closing: 'quarterly')
      monthly       = create(:net_income_config, book_closing: 'monthly')
      
      expect(annually.beginning_date_setter).to eq      NetIncomeConfigs::DateSetters::Annually
      expect(semi_annually.beginning_date_setter).to eq NetIncomeConfigs::DateSetters::SemiAnnually
      expect(quarterly.beginning_date_setter).to eq     NetIncomeConfigs::DateSetters::Quarterly
      expect(monthly.beginning_date_setter).to eq       NetIncomeConfigs::DateSetters::Monthly
    end 
  end 
end
