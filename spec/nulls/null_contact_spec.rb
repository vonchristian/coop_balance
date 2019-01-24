require 'rails_helper'

describe NullContact do
  describe 'number' do
    it { expect(described_class.new.number).to eql 'No contact number' }
  end
end
