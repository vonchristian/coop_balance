require 'rails_helper'

module Addresses
  describe Province, type: :model do
    describe 'associations' do
      it { should have_many :municipalities }
      it { should have_many :barangays }
    end

    describe 'validations' do
    end
  end
end
