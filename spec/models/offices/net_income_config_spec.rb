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

  end
end
