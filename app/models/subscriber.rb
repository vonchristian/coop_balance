class Subscriber
  def self.find(id)
    user = User.find_by(id: id)
    member = Member.find_by(id: id)
    organization = Organization.find_by(id: id)
    if member.present?
      member
    elsif user.present?
      user
    elsif organization.present?
      organization
    end
  end
end
