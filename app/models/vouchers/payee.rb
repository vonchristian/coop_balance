module Vouchers
  class Payee
    def self.all
      User.all +
      Supplier.all +
      Member.all
    end
    def self.text_search(search_term)
      User.text_search(search_term) +
      Supplier.text_search(search_term) +
      Member.text_search(search_term)
    end
  end
end
