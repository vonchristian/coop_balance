User.general_manager.create(
  email: 'general_manager@coopcatalyst.ph',
  password: '11111111',
  password_confirmation: '11111111',
  first_name: "General",
  last_name: "Manager",
  department: Department.last,
  cooperative: Cooperative.last)


User.sales_clerk.create(
  email: 'sales_clerk@coopcatalyst.ph',
  password: '11111111',
  password_confirmation: '11111111',
  first_name: "Sales",
  last_name: "Clerk",
  department: Department.last,
  cooperative: Cooperative.last)

User.stock_custodian.create(
  email: 'stock_custodian@coopcatalyst.ph',
  password: '11111111',
  password_confirmation: '11111111',
  first_name: "Stock",
  last_name: "Custodian",
  department: Department.last,
  cooperative: Cooperative.last)

User.teller.create(
  email: 'teller@coopcatalyst.ph',
  password: '11111111',
  password_confirmation: '11111111',
  first_name: "Tell",
  last_name: "er",
  department: Department.last,
  cooperative: Cooperative.last)
