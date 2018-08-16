User.general_manager.create(
  email: 'general_manager@coopcatalyst.ph',
  password: '11111111',
  password_confirmation: '11111111',
  first_name: "General",
  last_name: "Manager",
  cooperative: Cooperative.last)


User.sales_clerk.create(
  email: 'sales_clerk@coopcatalyst.ph',
  password: '11111111',
  password_confirmation: '11111111',
  first_name: "Sales",
  last_name: "Clerk",
  cooperative: Cooperative.last)


User.teller.create(
  email: 'teller@coopcatalyst.ph',
  password: '11111111',
  password_confirmation: '11111111',
  first_name: "Tell",
  last_name: "er",
  cooperative: Cooperative.last)
