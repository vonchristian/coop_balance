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
    return User.find_by(id: customer_id) if User.find_by(id: customer_id).present?

    Member.find_by(id: customer_id).presence
  end
end
