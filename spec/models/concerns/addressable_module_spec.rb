require 'rails_helper'

describe AddressingModule do
  let(:member) { create(:member) { include AddressingModule } }

  describe 'associations' do
    it { expect(member).to have_many :addresses }
  end

  describe 'delegations' do
    it { expect(member).to delegate_method(:complete_address).to(:current_address).with_prefix }
    it { expect(member).to delegate_method(:details).to(:current_address).with_prefix }
    it { expect(member).to delegate_method(:barangay_name).to(:current_address).with_prefix }
    it { expect(member).to delegate_method(:street_name).to(:current_address).with_prefix }
  end

  describe 'current_address' do
    it 'with valid address' do
      address = create(:address, addressable: member)

      expect(member.current_address).to eql address
    end
    it 'with null address' do
      expect(member.current_address.class).to eq NullAddress
    end
  end
end
