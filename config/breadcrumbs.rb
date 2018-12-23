# MEMBERS
crumb :members do
  link "Members", members_path
end

crumb :member do |member|
  link member.first_and_last_name, member_path(member)
  parent :members
end

crumb :member_loans do |member|
  link "Loans", member_loans_path(member)
  parent :member, member
end

crumb :member_savings_accounts do |member|
  link "Savings Deposits", member_savings_accounts_path(member)
  parent :member, member
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

crumb :new_loans_module_loan_application do |member|
  link "New Loan Application", new_loans_module_loan_application_path(borrower_id: member.id, borrower_type: member.class.name)
  parent :member_loans, member
end

crumb :new_loans_module_loan_application_voucher do |loan_application|
  link "New Loan Application Voucher", new_loans_module_loan_application_voucher_path(loan_application_id: loan_application.id)
  parent :member_loans, loan_application.borrower
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


