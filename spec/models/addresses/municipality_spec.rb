require 'rails_helper'
module Addresses
  RSpec.describe Municipality, type: :model do
    describe 'associations' do
      it { is_expected.to have_many :barangays }
      it { is_expected.to have_many :streets }
    end
    describe 'validations' do
      it { is_expected.to validate_presence_of :name }
      it do
        is_expected.to validate_uniqueness_of(:name).scoped_to(:province_id)
      end
    end
  end
end
