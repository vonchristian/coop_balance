require 'rails_helper'

describe TermParser do
  it 'returns the correct months' do
    expect(TermParser.new(1.5).number_of_months).to eq 1
    expect(TermParser.new(2).number_of_months).to eq 2
  end

  it 'returns the correct days' do
    expect(TermParser.new(1.5).number_of_days).to eql 16
    expect(TermParser.new(1).number_of_days).to eql 0
  end
end
