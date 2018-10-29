coop = Cooperative.find_or_create_by(name: 'Ifugao Public Servants Multipurpose Cooperative', abbreviated_name: "IPSMPC", address: "Capitol Compound", contact_number: "0915-699-0481", registration_number: '12313213')
coop.accounts << AccountingModule::Account.all
office = coop.main_offices.create(name: "Main Offce", address: "Capitol Compound", contact_number: '23e2312')
general_manager = User.general_manager.create!(
  email: 'general_manager2@coopcatalyst.ph',
  password: '11111111',
  password_confirmation: '11111111',
  first_name: "General",
  last_name: "Manager",
  cooperative: coop,
  office: office)
genesis_account = AccountingModule::Asset.create(name: "Genesis Account", active: false, code: "Genesis Code")
  entry = AccountingModule::Entry.new(
    office:              office,
    cooperative:         coop,
    commercial_document: coop,
    description:         "Genesis entry",
    recorder:            general_manager,
    reference_number:    "Genesis",
    previous_entry_id:   "",
    previous_entry_hash:   "Genesis previous entry hash",
    encrypted_hash:      "Genesis encryted hash",
    entry_date:          Date.today)
    entry.debit_amounts.build(
        account: genesis_account,
        amount: 0,
        commercial_document: coop)
    entry.credit_amounts.build(
        account: genesis_account,
        amount: 0,
        commercial_document: coop)
  entry.save!
