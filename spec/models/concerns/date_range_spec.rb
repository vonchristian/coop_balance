require 'rails_helper'

describe DateRange do
  it '#range' do
    range = (DateRange.new(from_date: Date.today.beginning_of_month, to_date: Date.today.end_of_month).range)
    expect(range).to eql Date.today.beginning_of_month.strftime('%Y-%m-%d 00:00:00 +0800')..Date.today.end_of_month.strftime('%Y-%m-%d 23:59:59 +0800')
  end
  describe '#start_date' do
    it 'returns from_date if is_a?(Date)' do
      expect(DateRange.new(from_date: Date.today, to_date: Date.today.end_of_month).start_date).to eql((Date.today).strftime('%Y-%m-%d 00:00:00 +0800'))
    end
    it 'parses from_date if is a string' do
      start_date = (DateRange.new(from_date: '01/01/2019', to_date: '01/01/2019').start_date)
      expect(start_date).to eql DateTime.parse('01/01/2019').strftime('%Y-%m-%d 00:00:00 +0800')
    end
  end
  describe '#end_date' do
    it 'returns to_date if is_a?(Date)' do
      expect(DateRange.new(from_date: Date.today, to_date: Date.today.end_of_month).end_date).to eql((Date.today.end_of_month).strftime('%Y-%m-%d 23:59:59 +0800'))
    end
      it 'parses to_date if is a string' do
        to_date = (DateRange.new(from_date: '01/01/2019', to_date: '01/01/2019').end_date)
        expect(to_date).to eql DateTime.parse('01/01/2019').strftime('%Y-%m-%d 23:59:59 +0800')
    end
  end
end
