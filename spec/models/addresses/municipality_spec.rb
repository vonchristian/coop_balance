require 'rails_helper'
module Addresses
  RSpec.describe Municipality, type: :model do
    describe 'associations' do 
      it { is_expected.to have_many :barangays }
      it { is_expected.to have_many :streets }
    end
  end
end  