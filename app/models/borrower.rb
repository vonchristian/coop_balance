class Borrower
  def self.all
    User.all +
    Member.all +
    Organization.all
  end
  def self.find(id)
    user = User.find_by_id(id)
    member = Member.find_by_id(id)
    organization = Organization.find_by_id(id)
    if member.present?
      member
    elsif user.present?
      user
    elsif organization.present?
      organization
    end
  end
end
