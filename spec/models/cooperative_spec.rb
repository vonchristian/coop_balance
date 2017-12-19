require 'rails_helper'

RSpec.describe Cooperative, type: :model do
  describe 'associations' do
    it { is_expected.to have_many :offices }
    it { is_expected.to have_many :store_fronts }
  end
  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :registration_number }
    it { is_expected.to validate_uniqueness_of :registration_number }
    it { is_expected.to validate_uniqueness_of :name }
  end
end
