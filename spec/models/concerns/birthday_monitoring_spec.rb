require 'rails_helper'

describe BirthdayMonitoring do
  extend BirthdayMonitoring
    let(:february_12_1990_member) { create(:member, date_of_birth: Date.parse('12/02/1990'))}
    let(:march_14_2012_member)    { create(:member, date_of_birth: Date.parse('14/03/2012'))}
    it "birthday_on_month(month)" do
      expect(Member.birthday_on_month(2)).to include(february_12_1990_member)
      expect(Member.birthday_on_month(2)).to_not include(march_14_2012_member)
    end

    it "birthday_on_day(day)" do
      expect(Member.birthday_on_day(12)).to include(february_12_1990_member)
      expect(Member.birthday_on_day(12)).to_not include(march_14_2012_member)
    end

    it "birthday_on_year(year)" do
      expect(Member.birthday_on_year(1990)).to include(february_12_1990_member)
      expect(Member.birthday_on_year(2012)).to include(march_14_2012_member)
    end
end
