class Borrower
  def self.all
    User.all +
    Member.all +
    Organization.all
  end
end
