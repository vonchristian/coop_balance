require 'rails_helper'

describe Relationship, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to :relationee }
    it { is_expected.to belong_to :relationer }
  end
  describe 'validations' do
    it { is_expected.to validate_presence_of :relationee_id }
    it { is_expected.to validate_presence_of :relationer_id }
    it { is_expected.to validate_presence_of :relationer_type }
    it { is_expected.to validate_presence_of :relationship_type }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:relationship_type).with(
      [ :father,
        :mother,
        :son,
        :daughter
      ]) }
  end
  describe 'delegations' do
    it { is_expected.to delegate_method(:name).to(:relationer).with_prefix }
    it { is_expected.to delegate_method(:name).to(:relationee).with_prefix }
  end

end
