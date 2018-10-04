module Registries
  class OrganizationRegistry < Registry
    def parse_for_records
      book = Spreadsheet.open(spreadsheet.path)
      sheet = book.worksheet(0)
      transaction do
        sheet.each 1 do |row|
          if !row[0].nil?
            create_organization(row)
          end
        end
      end
    end
    private
    def create_organization(row)
      Organization.find_or_create_by(name: row[0])
    end
  end
end
