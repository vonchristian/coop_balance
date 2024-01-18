require 'rails_helper'

module NetIncomeConfigs
  module DateSetters
    describe Quarterly do
      it 'beginning_date' do
        quarterly      = create(:net_income_config, book_closing: 'quarterly')

        beginning_date = described_class.new(net_income_config: quarterly, date: Date.current.next_quarter).beginning_date

        expect(beginning_date).to eql Date.current.beginning_of_year.next_quarter.beginning_of_day
      end

      it 'ending_date' do
        quarterly   = create(:net_income_config, book_closing: 'quarterly')

        ending_date = described_class.new(net_income_config: quarterly, date: Date.current.next_quarter).ending_date

        expect(ending_date).to eql Date.current.next_quarter.end_of_quarter.end_of_day
      end
    end
  end
end