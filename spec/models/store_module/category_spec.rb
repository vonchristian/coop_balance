require 'rails_helper'

module StoreModule
  RSpec.describe Category, type: :model do
    describe 'associations' do
      it { is_expected.to have_many :products }
    end
    describe 'validations' do
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_uniqueness_of :name }
    end
  end
end
