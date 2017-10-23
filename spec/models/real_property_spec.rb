require 'rails_helper'

describe RealProperty do
  context 'associations' do 
  	it { is_expected.to belong_to :member } 
    it { is_expected.to belong_to :owner } 
  	it { is_expected.to have_many :appraisals }
  	it { is_expected.to have_many :appraisers }
    it { is_expected.to have_many :pictures }
  end
end
