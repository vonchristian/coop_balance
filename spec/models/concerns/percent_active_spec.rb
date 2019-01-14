require 'rails_helper'

describe PercentActive do
  describe 'percent_active(args={})' do
    it 'with accounts' do
      10.times do
        member =create(:member, last_transaction_date: Date.today)
      end

      10.times do
        inactive_member =create(:member, last_transaction_date: Date.today.last_year)
      end

      expect(Member.percent_active(from_date: Date.today.beginning_of_year, to_date: Date.today.end_of_year)).to eql (50.0)
    end

    it 'without accounts' do
      expect(Member.percent_active).to eql 0
    end
  end
end
