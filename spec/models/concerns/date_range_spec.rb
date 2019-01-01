require 'rails_helper'

describe DateRange do
  it '#range' do
    expect(DateRange.new(from_date: Date.today.beginning_of_month, to_date: Date.today.end_of_month).range).to eql(Date.today.beginning_of_month..Date.today.end_of_month)
  end
  describe '#start_date' do
    it 'returns from_date if is_a?(Date)' do
      expect(DateRange.new(from_date: Date.today, to_date: Date.today.end_of_month).start_date).to eql(Date.today)
    end
    it 'parses from_date if is a string' do
      expect(DateRange.new(from_date: '01/01/2019', to_date: '01/01/2019').start_date).to eql DateTime.parse('01/01/2019')
    end
  end
  describe '#end_date' do
    it 'returns to_date if is_a?(Date)' do
      expect(DateRange.new(from_date: Date.today, to_date: Date.today.end_of_month).end_date).to eql(Date.today.end_of_month)
    end
      it 'parses to_date if is a string' do
      expect(DateRange.new(from_date: '01/01/2019', to_date: '01/01/2019').end_date).to eql DateTime.parse('01/01/2019')
    end
  end
end
