require 'rails_helper'

RSpec.describe Registry, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to :cooperative }
    it { is_expected.to belong_to :store_front }
    it { is_expected.to belong_to :office }
    it { is_expected.to belong_to :employee }
  end
end
