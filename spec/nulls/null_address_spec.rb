require 'rails_helper'

describe NullAddress do
  it '#complete_address' do
    expect(described_class.new.complete_address).to eql 'No address entered'
  end
end 
