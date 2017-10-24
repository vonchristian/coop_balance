class AccountNumberGenerator
  def self.generate_account_number(account)
    Digest::SHA1.hexdigest([Time.now, rand].join)
  end
end
