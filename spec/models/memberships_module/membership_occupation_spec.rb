require 'rails_helper'

module MembershipsModule
  describe MemberOccupation do
    describe 'associations' do
      it { is_expected.to belong_to :occupation }
      it { is_expected.to belong_to :member }
    end
  end
end

