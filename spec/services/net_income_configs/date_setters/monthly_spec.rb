require 'rails_helper'

module NetIncomeConfigs
  module DateSetters
    describe Monthly do
      it 'beginning_date' do
        monthly        = create(:net_income_config, book_closing: 'monthly')

        beginning_date = described_class.new(net_income_config: monthly, date: Date.current.next_quarter).beginning_date

        expect(beginning_date).to eql Date.current.beginning_of_year.next_quarter.beginning_of_month.beginning_of_day
      end

      it 'ending_date' do
        monthly = create(:net_income_config, book_closing: 'monthly')

        ending_date = described_class.new(net_income_config: monthly, date: Date.current.next_quarter).ending_date

        expect(ending_date.to_date).to eql Date.current.next_quarter.end_of_month.end_of_day.to_date
      end
    end
  end
end