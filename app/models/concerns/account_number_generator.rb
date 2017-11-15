class AccountNumberGenerator
  def self.generate_account_number(account)
    SecureRandom.uuid.gsub('-','').to_s.last(12).upcase
  end
end
