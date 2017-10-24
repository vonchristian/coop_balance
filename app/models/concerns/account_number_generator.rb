class AccountNumberGenerator
  def self.generate_account_number(account)
    SecureRandom.uuid.gsub('-','').upcase
  end
end
