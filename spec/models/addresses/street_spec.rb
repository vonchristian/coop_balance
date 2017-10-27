require 'rails_helper'

module Addresses
  RSpec.describe Street, type: :model do
    describe 'associations' do 
      it { is_expected.to belong_to :barangay }
      it { is_expected.to belong_to :municipality }
    end

    describe 'validations' do 
      it { is_expected.to validate_presence_of :name }
      it do 
        is_expected.to validate_uniqueness_of(:name).scoped_to(:barangay_id)
      end
    end 
  end
end