module MemberAccounts
  class AccountRegistration
    include ActiveModel::Model
    attr_accessor :first_name, :middle_name, :last_name, :email, :password, :password_confirmation

    def register!
      create_member_account
    end
    private
    def create_member_account
      MemberAccount.create(
        member: find_member,
        email: email,
        password: password,
        password_confirmation: password_confirmation)
    end
    def find_member
      Member.find_or_create_by(
        first_name: first_name,
        middle_name: middle_name,
        last_name: last_name)
    end
  end
end
