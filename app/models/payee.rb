class Payee
  def self.all
    User.all +
    Supplier.all +
    Member.all
  end
end
