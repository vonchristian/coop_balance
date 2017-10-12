class Registry < ApplicationRecord
  
  has_attached_file :spreadsheet, :path => ":rails_root/public/system/:attachment/:id/:filename"
  do_not_validate_attachment_file_type :spreadsheet
  def parse_for_records
    book = Spreadsheet.open(spreadsheet.path)
    sheet = book.worksheet(0)
    transaction do
      sheet.each 1 do |row|
        if !row[0].nil? 
          create_or_find_member(row)
          create_saving_products(row)
          create_savings(row)
          create_entry(row)
        end
      end
    end
  end

  def create_or_find_member(row)
    Member.find_or_create_by(first_name: row[0], last_name: row[1])
  end
  def create_saving_products(row)
    CoopServicesModule::SavingProduct.find_or_create_by(name: row[4], interest_rate: row[5], interest_recurrence: row[6])
  end
  def find_saving_product(row)
    CoopServicesModule::SavingProduct.find_by(name: row[4])
  end
  def find_member(row)
    Member.find_by(first_name: row[0], last_name: row[1])
  end
  def create_savings(row)
    find_member(row).savings.create(account_number: row[3].to_s.rjust(12, '0'))
  end
  def find_savings(row)
    MembershipsModule::Saving.find_by(account_number: row[3].to_s.rjust(12, '0'))
  end 
  def create_entry(row)
    find_savings(row).entries.create!(entry_type: 'deposit',  description: 'Savings deposit',  entry_date: Time.zone.now,
    debit_amounts_attributes: [account: debit_account, amount: row[2]],
    credit_amounts_attributes: [account: credit_account, amount: row[2]])
  end

  def debit_account
    AccountingModule::Account.find_by(name: "Cash on Hand (Treasury)")
  end

  def credit_account
    AccountingModule::Account.find_by(name: "Savings Deposits")
  end
end
