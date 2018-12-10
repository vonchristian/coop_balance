require 'rails_helper'

describe PercentActive do
  it 'percent_active(args={})' do
    10.times do
      member =create(:member, last_transaction_date: Date.today)
    end
    10.times do
      inactive_member =create(:member, last_transaction_date: Date.today.last_year)
    end
    expect(Member.percent_active(from_date: Date.today.beginning_of_year, to_date: Date.today.end_of_year)).to eql (50.0)
  end
end
