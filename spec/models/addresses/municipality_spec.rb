require 'rails_helper'
module Addresses
  RSpec.describe Municipality, type: :model do
    describe 'associations' do
      it { should belong_to :province }
      it { should have_many :barangays }
      it { should have_many :streets }
    end

    describe 'validations' do
      it { should validate_presence_of :name }
      it { should validate_uniqueness_of(:name).scoped_to(:province_id) }
    end
  end
end
