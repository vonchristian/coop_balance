require 'rails_helper'

module Organizations
  describe OrganizationMember do
    describe 'associations' do
      it { should belong_to :organization }
      it { should belong_to :organization_membership }
    end
  end
end
