class BalanceStatusChecker
  attr_reader :account, :product

  def initialize(args)
    @account = args.fetch(:account)
    @product = args.fetch(:product)
  end

  def set_balance_status
    if account.balance >= product.minimum_balance
      account.update!(has_minimum_balance:  true)
    elsif account.balance < product.minimum_balance
      account.update!(has_minimum_balance:  false)
    end
  end
end
