require 'rails_helper'

describe PercentActive do
  describe 'percent_active(args={})' do
    it 'with accounts' do
      10.times do
        create(:member, last_transaction_date: Time.zone.today)
      end

      10.times do
        create(:member, last_transaction_date: Time.zone.today.last_year)
      end

      expect(Member.percent_active(from_date: Time.zone.today.beginning_of_year, to_date: Time.zone.today.end_of_year)).to be(50.0)
    end

    it 'without accounts' do
      expect(Member.percent_active).to be 0
    end
  end
end
