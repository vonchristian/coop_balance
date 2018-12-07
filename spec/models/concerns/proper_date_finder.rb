require 'rails_helper'

describe ProperDateFinder do
  it '#proper_date' do
    operating_days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    expect(ProperDateFinder.new(Date.today.sunday.prev_day, operating_days).proper_date).to eql Date.today.sunday.next_weekday
    expect(ProperDateFinder.new(Date.today.sunday, operating_days).proper_date).to eql Date.today.sunday.next_weekday
    expect(ProperDateFinder.new(Date.today.next_weekday, operating_days).proper_date).to eql Date.today.next_weekday
  end
end
