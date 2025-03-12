require 'rails_helper'

describe TimeRange do
  it '#range' do
    range = described_class.new(from_time: Date.current.beginning_of_day, to_time: Time.zone.today.end_of_day).range

    expect(range).to eql(Date.current.all_day)
  end

  describe '#start_time' do
    it 'returns from_time if is_a?(Time)' do
      expect(described_class.new(from_time: Time.zone.now, to_time: Time.zone.now.end_of_day).start_time.strftime('%-l:%M %p')).to eql(Time.zone.now.strftime('%-l:%M %p'))
    end

    it 'returns a parsed string to a kind_of?(Time)' do
      expect(described_class.new(from_time: '12/1/2020 10:00', to_time: Time.zone.now.end_of_day).start_time.strftime('%-l:%M %p')).to eql('10:00 AM')
    end
  end

  describe '#end_time' do
    it 'returns end_time if is_a?(Time)' do
      expect(described_class.new(from_time: Time.zone.now, to_time: Time.zone.now).end_time.strftime('%-l:%M %p')).to eql(Time.zone.now.strftime('%-l:%M %p'))
    end

    it 'returns a parsed string to a kind_of?(Time)' do
      expect(described_class.new(from_time: Time.zone.now, to_time: '12/1/2020 10:00').end_time.strftime('%-l:%M %p')).to eql('10:00 AM')
    end
  end
end
