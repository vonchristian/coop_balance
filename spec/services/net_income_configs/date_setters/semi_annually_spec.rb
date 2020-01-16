require 'rails_helper'

module NetIncomeConfigs 
  module DateSetters
    describe SemiAnnually do 
      
      describe 'beginning_date' do 
        it 'first_part_of_year' do 
          semi_annually  = create(:net_income_config, book_closing: 'semi_annually')
          
          beginning_date = described_class.new(net_income_config: semi_annually, date: Date.current.beginning_of_year).beginning_date

          expect(beginning_date.to_date).to eql Date.current.beginning_of_year.beginning_of_day.to_date
        end 

        it 'second_part_of_year' do 
          semi_annually  = create(:net_income_config, book_closing: 'semi_annually')
          
          beginning_date = described_class.new(net_income_config: semi_annually, date: Date.current.beginning_of_year + 7.months).beginning_date

          expect(beginning_date.to_date).to eql Date.current.beginning_of_year.next_quarter.next_quarter.beginning_of_month.to_date
        end 
      end
      
      describe 'ending_date' do 
        it 'first_part_of_year' do 
          semi_annually = create(:net_income_config, book_closing: 'semi_annually')
          
          ending_date   = described_class.new(net_income_config: semi_annually, date: Date.current.beginning_of_year).ending_date

          expect(ending_date.to_date).to eql Date.current.beginning_of_year.next_quarter.end_of_quarter.to_date
        end 

        it 'second_part_of_year' do 
          semi_annually = create(:net_income_config, book_closing: 'semi_annually')
          
          ending_date   = described_class.new(net_income_config: semi_annually, date: Date.current.beginning_of_year + 7.months).ending_date

          expect(ending_date.to_date).to eql Date.current.end_of_year
        end 
      end

      
    end 
  end 
end 