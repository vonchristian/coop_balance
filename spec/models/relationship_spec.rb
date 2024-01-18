require 'rails_helper'

describe Relationship, type: :model do
  describe 'associations' do
    it { should belong_to :relationee }
    it { should belong_to :relationer }
  end

  describe 'validations' do
    it { should validate_presence_of :relationee_id }
    it { should validate_presence_of :relationer_id }
    it { should validate_presence_of :relationer_type }
    it { should validate_presence_of :relationship_type }
  end

  describe 'enums' do
    it {
      expect(subject).to define_enum_for(:relationship_type).with(
        %i[father
           mother
           son
           daughter]
      )
    }
  end

  describe 'delegations' do
    it { should delegate_method(:name).to(:relationer).with_prefix }
    it { should delegate_method(:name).to(:relationee).with_prefix }
  end
end
