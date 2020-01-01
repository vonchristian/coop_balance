module LoansModule
  class PaymentPolicy
    attr_reader :user, :loan
    
    def initialize(user, loan)
      @user = user
      @loan = loan
    end

    def new?
      user.cash_accounts.present?
    end

    def create?
      new?
    end
  end
end
