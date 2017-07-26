require 'rails_helper'

module WarehouseModule
	RSpec.describe RawMaterial, type: :model do
	  describe 'associations' do 
	  	it { is_expected.to have_many :raw_material_stocks }
	  	it { is_expected.to have_many :work_in_progress_materials }
	  	it { is_expected.to have_many :finished_good_materials }
	  end
	end
end