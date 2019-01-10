class MinimumBalanceChecker
	attr_reader :account, :product

	def initialize(args)
		@account = args.fetch(:account)
		@product = args.fetch(:product)
	end

	def check_balance!
    if account.balance >= product.minimum_balance
      account.update_attributes!(has_minimum_balance:  true)
    elsif account.balance < product.minimum_balance
      account.update_attributes!(has_minimum_balance:  false)
    end
  end
end
