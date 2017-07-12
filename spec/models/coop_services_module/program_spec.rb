require 'rails_helper'

module CoopServicesModule
  describe Program do
  	context 'associations' do 
  		it { is_expected.to have_many :subscribers }
  	end
  	context 'validations' do 
  		it { is_expected.to validate_presence_of :name }
  		it { is_expected.to validate_uniqueness_of :name }
  	end

  	it ".default_programs" do 
  		default_program = create(:program, default_program: true)
  		not_default_program = create(:program, default_program: false)

  		expect(CoopServicesModule::Program.default_programs).to include(default_program)
  		expect(CoopServicesModule::Program.default_programs).to_not include(not_default_program)
    end
  end
end
