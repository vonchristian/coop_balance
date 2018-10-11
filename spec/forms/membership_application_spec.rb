require 'rails_helper'

describe MembershipApplication do
  describe 'validations' do
    it { is_expected.to validate_presence_of :first_name }
  end
end
