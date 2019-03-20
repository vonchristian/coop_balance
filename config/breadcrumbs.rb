# MEMBERS
crumb :members do
  link "Members", members_path
end

crumb :member do |member|
  if member.class.name == "Member"
    link member.first_middle_and_last_name, member_path(member)
    parent :members
  elsif member.class.name == "Organization"
    link member.try(:abbreviated_name) || member.name, organization_path(member)
    parent :organizations
  end
end

crumb :member_loans do |member|
  link "Loans", member_loans_path(member)
  parent :member, member
end

crumb :member_savings_accounts do |member|
  if member.class.name == "Member"
    link "Savings Deposits", member_savings_accounts_path(member)
    parent :member, member
  elsif member.class.name == "Organization"
    link "Savings Deposits", organization_savings_accounts_path(member)
    parent :organization, member
  end
end

crumb :member_share_capitals do |member|
  link "Share Capitals", member_share_capitals_path(member)
  parent :member, member
end

crumb :member_time_deposits do |member|
  link "Time Deposits", member_time_deposits_path(member)
  parent :member, member
end

crumb :member_subscriptions do |member|
  link "Program Subscriptions", member_subscriptions_path(member)
  parent :member, member
end

crumb :member_settings do |member|
  link "Settings", member_settings_path(member)
  parent :member, member
end

crumb :new_member_merging_line_item do |member|
  link "Merge Account", new_member_merging_line_item_path(member_id: member.id)
  parent :member, member
end

#Member Loans

crumb :new_loans_module_loan_application do |borrower|
  link "New Loan Application", new_loans_module_loan_application_path(borrower_id: borrower.id, borrower_type: borrower.class.name)
  parent :member, borrower
end

crumb :new_loans_module_loan_application_voucher do |loan_application|
  link "New Loan Application Voucher", new_loans_module_loan_application_voucher_path(loan_application_id: loan_application.id)
  parent :member_loans, loan_application.borrower
end

crumb :loan_details do |loan|
  link "Details", loan_path(loan)
  parent :member_loans, loan.borrower
end

crumb :loans_module_loan_amortization_schedules do |loan|
  link "Amortizations", loans_module_loan_amortization_schedules_path(loan)
  parent :member_loans, loan.borrower
end

crumb :loan_payments do |loan|
  link "Payments", loan_payments_path(loan)
  parent :member_loans, loan.borrower
end

crumb :new_loan_payment do |loan|
  link "New Payment", new_loan_payment_path(loan)
  parent :member_loans, loan.borrower
end

crumb :loan_notes do |loan|
  link "Notes", loan_notes_path(loan)
  parent :member_loans, loan.borrower
end

crumb :loan_settings do |loan|
  link "Settings", loan_settings_path(loan)
  parent :member_loans, loan.borrower
end

crumb :loans_module_amortization_schedule_details do |amortization_schedule|
  link "Details", loans_module_amortization_schedule_path(amortization_schedule)
  parent :loans_module_loan_amortization_schedules, amortization_schedule.loan
end

# Member Savings 

crumb :new_savings_account_application do |depositor|
  link "New Savings Account", new_savings_account_application_path(depositor_id: depositor.id, depositor_type: depositor.class.name)
  if depositor.class.name == "Member"
    parent :member, depositor
  elsif depositor.class.name == "Organization"
    parent :organization, depositor
  end
end

crumb :savings_account_details do |savings_account|
  link "Details", savings_account_path(savings_account)
  parent :member_savings_accounts, savings_account.depositor
end

crumb :savings_account_settings do |savings_account|
  link "Settings", savings_account_settings_path(savings_account)
  parent :member_savings_accounts, savings_account.depositor
end

crumb :savings_account_transactions do |savings_account|
  link "Transactions", savings_account_transactions_path(savings_account)
  parent :member_savings_accounts, savings_account.depositor
end

crumb :savings_account_merging do |savings_account|
  link "Accounts Merging", new_savings_account_merging_line_item_path(savings_account_id: savings_account.id)
  parent :savings_account_settings, savings_account
end

crumb :savings_account_closing do |savings_account|
  link "Account Closing", new_savings_account_account_closing_path(savings_account_id: savings_account.id)
  parent :savings_account_settings, savings_account
end

crumb :savings_account_deposit do |savings_account|
  link "New Deposit", new_savings_account_deposit_path(savings_account_id: savings_account.id)
  parent :member_savings_accounts, savings_account.depositor
end

crumb :savings_account_withdrawal do |savings_account|
  link "Withdrawal", new_savings_account_withdrawal_path(savings_account_id: savings_account.id)
  parent :member_savings_accounts, savings_account.depositor
end

crumb :savings_account_balance_transfer do |savings_account|
  link "Balance Transfer", new_savings_account_balance_transfer_destination_account_path(savings_account_id: savings_account.id)
  parent :savings_account_settings, savings_account
end

crumb :savings_account_balance_transfer_form do |savings_account|
  link "Balance Transfer Form", new_savings_account_balance_transfer_path(savings_account_id: savings_account.id)
  parent :savings_account_settings, savings_account
end

# Member Share Capital

crumb :new_share_capital_application do |subscriber|
  link "Share Capital Openning", new_share_capital_application_path(depositor_id: subscriber.id, depositor_type: subscriber.class.name)
  parent :member, subscriber
end

crumb :share_capital_details do |share_capital|
  link "Details", share_capital_path(share_capital)
  parent :member_share_capitals, share_capital.subscriber
end

crumb :share_capital_settings do |share_capital|
  link "Settings", share_capital_settings_path(share_capital)
  parent :member_share_capitals, share_capital.subscriber
end

crumb :share_capital_transactions do |share_capital|
  link "Transactions", share_capital_transactions_path(share_capital)
  parent :member_share_capitals, share_capital.subscriber
end

crumb :share_capital_merging do |share_capital|
  link "Accounts Merging", new_share_capital_merging_line_item_path(share_capital_id: share_capital.id)
  parent :share_capital_settings, share_capital
end

crumb :share_capital_balance_transfer do |share_capital|
  link "Balance Transfer", new_share_capital_balance_transfer_destination_account_path(share_capital_id: share_capital.id)
  parent :share_capital_settings, share_capital
end

crumb :share_capital_balance_transfer_form do |share_capital|
  link "Balance Transfer Form", new_share_capital_balance_transfer_path(share_capital_id: share_capital.id)
  parent :share_capital_settings, share_capital
end

# Member Time Deposits

crumb :new_time_deposit_application do |depositor|
  link "Time Deposit Openning", new_time_deposit_application_path(depositor_id: depositor.id, depositor_type: depositor.class.name)
  parent :member, depositor
end

crumb :time_deposit_details do |time_deposit|
  link "Details", time_deposit_path(time_deposit)
  parent :member_time_deposits, time_deposit.depositor
end

crumb :time_deposit_settings do |time_deposit|
  link "Settings", time_deposit_settings_path(time_deposit)
  parent :member_time_deposits, time_deposit.depositor
end

crumb :time_deposit_transactions do |time_deposit|
  link "Transactions", time_deposit_transactions_path(time_deposit)
  parent :member_time_deposits, time_deposit.depositor
end

crumb :time_deposit_withdrawal do |time_deposit|
  link "Withdrawal", new_time_deposit_withdrawal_path(time_deposit_id: time_deposit.id)
  parent :member_time_deposits, time_deposit.depositor
end

crumb :time_deposit_withdrawal_voucher do |time_deposit|
  link "Withdrawal Voucher", time_deposit_withdrawal_voucher_path(time_deposit_id: time_deposit.id, id: Vouchers::VoucherAmount.debit.where(commercial_document: time_deposit).last.voucher.id)
  parent :time_deposit_details, time_deposit
end

# ORGANIZATIONS

crumb :organizations do
  link "Organizations", organizations_path
end

crumb :organization do |organization|
  link organization.try(:abbreviated_name) || organization.name, organization_path(organization)
  parent :organizations
end

crumb :organization_savings_accounts do |organization|
  link "Savings Accounts", organization_savings_accounts_path(organization)
  parent :organization, organization
end
crumb :organization_settings do |organization|
  link "Settings", organization_settings_path(organization)
  parent :organization, organization
end
crumb :organization_members do |organization|
  link "Members", organization_members_path(organization)
  parent :organization, organization
end
crumb :organization_loans do |organization|
  link "Member Loans", organization_loans_path(organization)
  parent :organization, organization
end
crumb :accounting_dashboard do
  link "Accounting", accounting_module_index_path
end
crumb :entries do
  link 'Entries', accounting_module_entries_path
  parent :accounting_dashboard
end

crumb :entry do |entry|
  link "##{entry.reference_number}" || entry.description, accounting_module_entry_path(entry)
  parent :entries
end

crumb :share_capitals do
  link 'Share Capitals', share_capitals_path
end

crumb :share_capital do |share_capital|
  link share_capital.subscriber_name, share_capital_path(share_capital)
  parent :share_capitals
end
crumb :new_share_capital_capital_build_up do |share_capital|
  link 'New Capital Build Up', new_share_capital_capital_build_up_path(share_capital)
  # parent :share_capital, share_capital: share_capital
end
crumb :loans do
  link 'Loans', loans_path
end
crumb :loan do |loan|
  link "#{loan.borrower_name} - #{loan.loan_product_name}", loan_path(loan)
  parent :loans
end
crumb :loan_interests do |loan|
  link 'Interests', loan_path(loan)
  parent :loan, loan
end
