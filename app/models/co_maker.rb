class CoMaker
  def self.all
    Member.all + User.all
  end
  def self.text_search(search)
    Member.text_search(search) +
    User.text_search(search)
  end
end
