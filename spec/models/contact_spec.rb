require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to :contactable }
  end
end
