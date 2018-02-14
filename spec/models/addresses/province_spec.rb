require 'rails_helper'

module Addresses
  describe Province, type: :model do
    describe 'associations' do
      it { is_expected.to have_many :municipalities }
      it { is_expected.to have_many :barangays }
    end
    describe 'validations' do
    end
  end
end
