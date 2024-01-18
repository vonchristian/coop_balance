require 'rails_helper'

describe Contactable do
  let(:member) { create(:member) { include described_class } }

  describe 'associations' do
    it { expect(member).to have_many(:contacts) }
  end

  describe 'delegations' do
    it { expect(member).to delegate_method(:number).to(:current_contact).with_prefix }
  end

  describe 'current_contact' do
    it 'with valid contact' do
      contact = create(:contact, contactable: member, number: '009922')
      expect(member.current_contact).to eql contact
    end

    it 'with null contact' do
      expect(member.current_contact.class).to eql NullContact
    end
  end

  describe 'current_contact_number' do
    it 'with valid contact' do
      create(:contact, contactable: member, number: '009922')

      expect(member.current_contact_number).to eql '009922'
    end

    it 'with null contact' do
      expect(member.current_contact_number).to eql 'No contact number'
    end
  end
end
