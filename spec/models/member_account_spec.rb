require 'rails_helper'

RSpec.describe MemberAccount, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to :member }
  end
end
