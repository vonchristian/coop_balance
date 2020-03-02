class MembershipApplication
  include ActiveModel::Model
  attr_accessor :first_name, :middle_name, :last_name, :avatar,
  :date_of_birth, :account_number, :membership_category_id, :civil_status, :sex,
  :contact_number, :email, :office_id, :cooperative_id, :membership_date,
  :complete_address, :barangay_id, :municipality_id, :province_id

  validates :first_name, :last_name, :sex, :civil_status, :date_of_birth, :cooperative_id, presence: true
  validates :contact_number, :complete_address, :barangay_id, :municipality_id, :province_id, presence: true
  validate :unique_full_name

  def register!
    ActiveRecord::Base.transaction do
      create_member
      create_membership
      create_contact
      create_address
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
    last_transaction_date: Date.current)
    member.avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'default.png')), filename: 'default.png')

  end
  def avatar_asset
    if avatar.present?
      avatar
    else
      Rails.root.join('app', 'assets', 'images', 'default.png')
    end
  end

  def create_membership
    find_cooperative.memberships.create!(
      office_id:       office_id,
      cooperator:      find_member,
      account_number:  SecureRandom.uuid,
      membership_category_id: membership_category_id,
      membership_date: membership_date
    )
  end

  def create_tin
    if tin_number.present?
      find_member.tins.create!(number: tin_number)
    end
  end
  def create_contact
    find_member.contacts.create(number: contact_number)
  end

  def create_address
    find_member.addresses.create!(
      complete_address: complete_address,
      barangay_id: barangay_id,
      municipality_id: municipality_id,
      province_id: province_id
    )
  end

  def find_cooperative
    Cooperative.find(cooperative_id)
  end
  def unique_full_name
    errors[:last_name] << "Member already registered" if Member.find_by(first_name: first_name, middle_name: middle_name, last_name: last_name).present?
    errors[:first_name] << "Memberalready registered" if Member.find_by(first_name: first_name, middle_name: middle_name, last_name: last_name).present?
    errors[:middle_name] << "Member already registered" if Member.find_by(first_name: first_name, middle_name: middle_name, last_name: last_name).present?
  end
end
