class AccountNumberGenerator
  def self.generate_account_number(account)
    SecureRandom.uuid.gsub('-','').to_s.last(15).upcase
  end
end
