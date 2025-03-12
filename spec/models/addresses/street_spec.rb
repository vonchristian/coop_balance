require 'rails_helper'

module Addresses
  RSpec.describe Street, type: :model do
    describe 'associations' do
      it { should belong_to :barangay }
      it { should belong_to :municipality }
    end

    describe 'validations' do
      it { should validate_presence_of :name }

      it do
        expect(subject).to validate_uniqueness_of(:name).scoped_to(:barangay_id)
      end
    end
  end
end
