require 'rails_helper'

describe ProperDateFinder do
  it '#proper_date' do
    operating_days = %w[Monday Tuesday Wednesday Thursday Friday]
    expect(described_class.new(Time.zone.today.sunday.prev_day, operating_days).proper_date).to eql Time.zone.today.sunday.next_weekday
    expect(described_class.new(Time.zone.today.sunday, operating_days).proper_date).to eql Time.zone.today.sunday.next_weekday
    expect(described_class.new(Time.zone.today.next_weekday, operating_days).proper_date).to eql Time.zone.today.next_weekday
  end
end
