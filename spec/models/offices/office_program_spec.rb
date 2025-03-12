require 'rails_helper'

module Offices
  describe OfficeProgram, type: :model do
    describe 'associations' do
      it { should belong_to :office }
      it { should belong_to :program }
    end

    describe 'validations' do
      it 'unique program scoped to office' do
        program = create(:program)
        office  = create(:office)
        create(:office_program, office: office, program: program)
        office_program = build(:office_program, office: office, program: program)
        office_program.save

        expect(office_program.errors[:program_id]).to eql [ 'has already been taken' ]
      end
    end
  end
end
