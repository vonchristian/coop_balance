require 'rails_helper'

describe MembershipApplication do
  describe 'validations' do
    it { should validate_presence_of :first_name }
  end
end
