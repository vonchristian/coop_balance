require 'rails_helper'

describe Beneficiary do
  describe 'associations' do
    it { is_expected.to belong_to :member }
  end
  describe 'validations' do
    it { is_expected.to validate_presence_of :full_name }
    it { is_expected.to validate_presence_of :relationship }
  end
end
