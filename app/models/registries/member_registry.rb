require 'roo'
module Registries
  class MemberRegistry < Registry
    def parse_for_records
      member_spreadsheet = Roo::Spreadsheet.open(spreadsheet.path)
      header = member_spreadsheet.row(1)
      (2..member_spreadsheet.last_row).each do |i|
        row = Hash[[header, member_spreadsheet.row(i)].transpose]
        ActiveRecord::Base.transaction do 
          member = Member.where(first_name: row['First Name'], last_name: row['Last Name']).first_or_create! do |m|
            m.account_number = row["Account Number"]
            m.middle_name = row['Middle Name']
            m.sex = member_sex(row)
            m.date_of_birth = Date.parse(row["Date of Birth"].to_s) if row["Date of Birth"].present?
            m.civil_status = member_civil_status(row)
            Organizations::OrganizationMember.create(organization_membership: m, organization: Organization.find_or_create_by(name: row["Organization"]))
            Contact.create(contactable: m, number: row["Contact Number"])
            Address.create(addressable: m, current: true, municipality: Addresses::Municipality.find_by(name: row["Municipality"]), complete_address: row["Complete Address"])
            Tin.create(tinable: m, number: row["TIN Number"])
            Beneficiary.create(member_id: m.id, full_name: row["Beneficiary"], relationship: row["Relationship"])
            m.office = CoopConfigurationsModule::Offices::MainOffice.find_by(name: row["Office"])
            Membership.create!(account_number: row["Account Number"], cooperator: m, membership_date: membership_date(row), cooperative: Cooperative.last)
            m.save        
          end
        end
      end
    end

    def member_sex(row)
      if row['Sex'] == "F"
        "female"
      elsif row["Sex"] == "M"
        "male"
      end
    end

    def member_civil_status(row)
      if row['Civil Status'] == "S" || row["Civil Status"] == "single"
        "single"
      elsif row["Civil Status"] == "M" || row["Civil Status"] == "married"
        "married"
      elsif row["Civil Status"] == "W"
        "widow"
      end
    end

    def membership_date(row)
      Date.parse(row["Membership Date"].to_s) if row["Membership Date"].present?
    end
  end
end
