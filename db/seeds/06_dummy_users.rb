User.general_manager.create(
  email: 'general_manager@coopcatalyst.ph',
  password: '11111111',
  password_confirmation: '11111111',
  first_name: "General",
  last_name: "Manager",
  cooperative: Cooperative.last,
  office: Cooperatives::Office.last)

User.sales_clerk.create(
  email: 'sales_clerk@coopcatalyst.ph',
  password: '11111111',
  password_confirmation: '11111111',
  first_name: "Sales",
  last_name: "Clerk",
  cooperative: Cooperative.last,
  office: Cooperatives::Office.last)

User.teller.create(
  email: 'teller@coopcatalyst.ph',
  password: '11111111',
  password_confirmation: '11111111',
  first_name: "Tell",
  last_name: "er",
  cooperative: Cooperative.last,
  office: Cooperatives::Office.last)

User.bookkeeper.create(
  email: 'bookkeeper@coopcatalyst.ph',
  password: '11111111',
  password_confirmation: '11111111',
  first_name: "Book",
  last_name: "keeper",
  cooperative: Cooperative.last,
  office: Cooperatives::Office.last)

User.loan_officer.create(
  email: 'loan_officer@coopcatalyst.ph',
  password: '11111111',
  password_confirmation: '11111111',
  first_name: "Loan",
  last_name: "Officer",
  cooperative: Cooperative.last,
  office: Cooperatives::Office.last)
