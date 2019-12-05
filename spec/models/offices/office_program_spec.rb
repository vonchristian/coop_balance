require 'rails_helper'

module Offices
  describe OfficeProgram, type: :model do
    describe 'associations' do
      it { is_expected.to belong_to :office }
      it { is_expected.to belong_to :program }
      it { is_expected.to belong_to :level_one_account_category }
    end

    describe 'validations' do
      it 'unique program scoped to office' do
        program = create(:program)
        office  = create(:office)
        create(:office_program, office: office, program: program)
        office_program = build(:office_program, office: office, program: program)
        office_program.save

        expect(office_program.errors[:program_id]).to eql ['has already been taken']
      end
    end
  end
end
