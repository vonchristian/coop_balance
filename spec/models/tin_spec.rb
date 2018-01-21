require 'rails_helper'

RSpec.describe Tin, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to :tinable }
  end
end
