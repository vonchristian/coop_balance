require 'rails_helper'

RSpec.describe StoreFront, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to :cooperative }
    it { is_expected.to have_many :entries }
  end
end
