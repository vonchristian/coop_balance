module Vouchers
  class Payee
    def self.all
      Member.all +
      User.all +
      Organization.all +
      Supplier.all
    end

    def self.text_search(search)
      Member.text_search(search) +
      User.text_search(search) +
      Organization.text_search(search) +
      Supplier.all
    end

    def self.find_by_id(payee_id)
      return User.find_by_id(payee_id) if User.find_by_id(payee_id).present?
      return Member.find_by_id(payee_id) if Member.find_by_id(payee_id).present?
      return Organization.find_by_id(payee_id) if Organization.find_by_id(payee_id).present?
      return Supplier.find_by_id(payee_id) if Supplier.find_by_id(payee_id).present?
    end
  end
end

