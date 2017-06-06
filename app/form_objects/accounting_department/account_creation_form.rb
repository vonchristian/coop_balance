module AccountingDepartment
  class AccountCreationForm
    include ActiveModel::Model

    def register
      if valid?
        create_account
      end
    end
  end
end 
