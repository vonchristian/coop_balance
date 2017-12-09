module LoansModule
  class PaymentPolicy
    attr_reader :user, :loan
    def initialize(user, loan)
      @user = user
      @loan = loan
    end
    def new?
      user.cash_on_hand_account.present?
    end

    def create?
      new?
    end
  end
end
