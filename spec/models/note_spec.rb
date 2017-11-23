require 'rails_helper'

RSpec.describe Note, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to :noteable }
    it { is_expected.to belong_to :noter }
  end
end
