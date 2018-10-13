class Payee
  def self.all
    Member.all +
    User.all +
    Organization.all
  end

  def self.text_search(search)
    Member.text_search(search) +
    User.text_search(search) +
    Organization.text_search(search)
  end

  def self.find_by_id(payee_id)
    return User.find(payee_id) if User.find(payee_id).present?
    return Member.find(payee_id) if Member.find(payee_id).present?
    return Organization.find(payee_id) if Organization.find(payee_id).present?
  end
end
