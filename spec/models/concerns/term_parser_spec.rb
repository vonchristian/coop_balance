require 'rails_helper'

describe TermParser do
  it 'returns the correct months' do
    expect(described_class.new(term: 1.5).add_months).to eq(1.month)
    expect(described_class.new(term: 2).add_months).to eq(2.months)
  end

  it 'returns the correct days' do
    expect(described_class.new(term: 1.5).add_days).to eql(15.0.days)
    expect(described_class.new(term: 1).add_days).to eql(0.days)
  end

  it 'returns the correct parser' do
    expect(described_class.new(term: 1).parser).to eql(TermParsers::IntegerTermParser)
    expect(described_class.new(term: 1.5).parser).to eql(TermParsers::FloatTermParser)
    expect(described_class.new(term: 2.0).parser).to eql(TermParsers::FloatTermParser)
  end
end
