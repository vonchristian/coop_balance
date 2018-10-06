class MembershipApplication
  include ActiveModel::Model
  attr_accessor :first_name, :middle_name, :last_name, :avatar, :tin_number,
  :date_of_birth, :account_number, :membership_type, :civil_status, :sex,
  :contact_number, :email, :office_id, :cooperative_id

  validates :first_name, :middle_name, :last_name, :sex, :civil_status, :date_of_birth, :cooperative_id, presence: true
  validate :unique_full_name

  def save
    ActiveRecord::Base.transaction do
      create_member
    end
  end

  def find_member
    Member.find_by(account_number: account_number)
  end

  private
  def create_member
    member = Member.create!(
    account_number: account_number,
    first_name:     first_name,
    middle_name:    middle_name,
    last_name:      last_name,
    civil_status:   civil_status,
    sex:            sex,
    date_of_birth:  date_of_birth,
    contact_number: contact_number,
    email:          email,
    office_id:      office_id,
    avatar:         avatar_asset)
    create_membership(member)
    create_tin(member)
  end
  def avatar_asset
    if avatar.present?
      avatar
    else
      File.open("app/assets/images/logo.png")
    end
  end

  def create_membership(cooperator)
    Membership.create!(
      cooperator:       cooperator,
      account_number:   SecureRandom.uuid,
      membership_type:  membership_type,
      cooperative_id:   cooperative_id)
  end

  def create_tin(member)
    member.tins.create!(number: tin_number)
  end


  def unique_full_name
    errors[:last_name] << "Member already registered" if Member.find_by(first_name: first_name, middle_name: middle_name, last_name: last_name).present?
    errors[:first_name] << "Memberalready registered" if Member.find_by(first_name: first_name, middle_name: middle_name, last_name: last_name).present?
    errors[:middle_name] << "Member already registered" if Member.find_by(first_name: first_name, middle_name: middle_name, last_name: last_name).present?
  end
end
