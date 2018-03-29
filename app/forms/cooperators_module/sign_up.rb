module CooperatorsModule
  class SignUp
    include ActiveModel::Model
    attr_accessor :first_name,
                  :middle_name,
                  :last_name,
                  :email,
                  :password,
                  :password_confirmation
      validates :email, presence: true
    def process!
      ActiveRecord::Base.transaction do
        create_cooperator
      end
    end
    def cooperator
       Cooperator.find_by(
        email: email)
    end

    def create_cooperator
      Cooperator.create(
        first_name: first_name,
        middle_name: middle_name,
        last_name: last_name,
        email: email,
        password: password,
        password_confirmation: password_confirmation)
    end
  end
end
