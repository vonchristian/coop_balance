require 'rails_helper'

RSpec.describe Membership, type: :model do
  describe 'validations' do
    it { is_expected.to validate_uniqueness_of :account_number }
    it { is_expected.to validate_presence_of :account_number }
  end
end
