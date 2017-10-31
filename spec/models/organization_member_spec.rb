require 'rails_helper'

describe OrganizationMember do
  describe 'associations' do
    it { is_expected.to belong_to :organization }
    it { is_expected.to belong_to :organization_membership }
  end
end
