require 'rails_helper'

describe Beneficiary do
  describe 'associations' do
    it { should belong_to :member }
    it { should belong_to :cooperative }
  end

  describe 'validations' do
    it { should validate_presence_of :full_name }
    it { should validate_presence_of :relationship }
  end
end
