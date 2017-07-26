require 'rails_helper'

describe Appraisal do
  context 'associations' do 
  	it { is_expected.to belong_to :real_property }
  	it { is_expected.to belong_to :appraiser }
  end
end
