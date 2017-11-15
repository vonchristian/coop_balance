class MembershipApplicationForm
  include ActiveModel::Model
  attr_accessor :first_name, :middle_name, :last_name,
  :date_of_birth,
  :account_number,
  :pmes_date,
  :membership_type,
  :place_of_birth,
  :address,
  :civil_status,
  :sex,
  :contact_number,
  :email,
  :educational_attainment,
  :employer_address,
  :father_first_name,
  :father_middle_name,
  :father_last_name,
  :father_occupation,
  :father_address,
  :mother_first_name,
  :mother_middle_name,
  :mother_maiden_name,
  :mother_occupation,
  :mother_address,
  :spouse_first_name,
  :spouse_middle_name,
  :spouse_last_name,
  :spouses_occupation,
  :spouses_date_of_birth,
  :spouse_educational_attainment,
  :spouses_occupation,
   :application_date
  def save
    ActiveRecord::Base.transaction do
      create_member
    end
  end
  def find_member
    Membership.find_by(account_number: account_number).memberable
  end
  private
  def create_member
    member = Member.create(first_name: first_name, middle_name: middle_name, last_name: last_name, civil_status: civil_status, sex: sex, date_of_birth: date_of_birth, contact_number: contact_number, email: email)
    member.create_membership(account_number: account_number)
    member.share_capitals.find_or_create_by(share_capital_product: CoopServicesModule::ShareCapitalProduct.default_product)
  end

end
