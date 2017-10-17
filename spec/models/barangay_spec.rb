require 'rails_helper'

RSpec.describe Barangay, type: :model do
  describe 'associations' do 
    it { is_expected.to belong_to :municipality }
    it { is_expected.to have_many :streets }
  end
  describe 'validations' do 
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_uniqueness_of :name }
  end
end
