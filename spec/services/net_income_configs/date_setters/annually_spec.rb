require 'rails_helper'

module NetIncomeConfigs 
  module DateSetters
    describe Annually do 
      it 'beginning_date' do 
        annually       = create(:net_income_config, book_closing: 'annually')
        
        beginning_date = described_class.new(net_income_config: annually, date: Date.current).beginning_date

        expect(beginning_date).to eql Date.current.beginning_of_year.beginning_of_day
      end 

      it 'ending_date' do 
        annually    = create(:net_income_config, book_closing: 'annually')
        
        ending_date = described_class.new(net_income_config: annually, date: Date.current).ending_date

        expect(ending_date).to eql Date.current.end_of_year.end_of_day
      end 
    end 
  end 
end 