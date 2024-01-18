require 'rails_helper'

RSpec.describe Note, type: :model do
  describe 'associations' do
    it { should belong_to :noteable }
    it { should belong_to :noter }
  end
end
