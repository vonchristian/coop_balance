require 'rails_helper'

describe Archive do
  describe 'associations' do
    it { is_expected.to belong_to :record }
    it { is_expected.to belong_to :archiver }
  end
  describe 'validations' do
    it { is_expected.to validate_presence_of :remarks }
    it { is_expected.to validate_presence_of :archived_at }
    it { is_expected.to validate_presence_of :record }
    it { is_expected.to validate_presence_of :archiver }
  end
end
