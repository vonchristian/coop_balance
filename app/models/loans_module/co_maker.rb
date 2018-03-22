module LoansModule
  class CoMaker
    def self.all
      Member.all + User.all
    end
    def self.text_search(search)
      Member.text_search(search) +
      User.text_search(search)
    end
    def self.recommended_for(borrower)
      Member.where(last_name: borrower.last_name) +
      User.where(last_name: borrower.last_name)
    end
  end
end
