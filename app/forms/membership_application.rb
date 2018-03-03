class MembershipApplication
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks
  attr_accessor :first_name, :middle_name, :last_name, :avatar,
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
  :application_date,
  :share_capital_product_id,
  :membership_type,
  :office_id
  validates :first_name,
  :middle_name,
  :last_name,
  :sex,
  :date_of_birth,
  :contact_number,
  :civil_status, presence: true
  def save
    ActiveRecord::Base.transaction do
      create_member
      subscribe_member_to_programs
    end
  end

  def find_member
    Membership.find_by(account_number: account_number).memberable
  end

  private
  def create_member
    member = Member.create!(first_name: first_name, middle_name: middle_name, last_name: last_name, civil_status: civil_status, sex: sex, date_of_birth: date_of_birth, contact_number: contact_number, email: email, office_id: office_id)
   Membership.pending.create!(memberable: member, account_number: account_number, membership_type: membership_type)
   MembershipsModule::ShareCapital.create(subscriber: member, share_capital_product_id: share_capital_product_id)
  end
  def subscribe_member_to_programs
    CoopServicesModule::Program.subscribe(find_member)
  end
end
