class Customer
  def self.all
    Member.all +
    User.all
  end
  def self.text_search(search)
    Member.text_search(search) +
    User.text_search(search)
  end
  def self.find(customer_id)
    return User.find(customer_id) if User.find(customer_id).present?
    return Member.find(customer_id) if Member.find(customer_id).present?
  end
end
