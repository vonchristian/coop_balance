class MemberRegistrationForm
  include ActiveModel::Model
  include Paperclip::Glue
  attr_accessor :first_name, 
                :middle_name, 
                :last_name, 
                :sex, 
                :avatar, 
                :date_of_birth,
                :tin_number
  validates :first_name, :middle_name, :last_name, :sex, :date_of_birth, presence: true

  def save
    ActiveRecord::Base.transaction do
      save_member
      save_tin
    end
  end
  def save_member
    Member.find_or_create_by(first_name: first_name, middle_name: middle_name, last_name: last_name, sex: sex, date_of_birth: date_of_birth, avatar: avatar)
  end
  def save_tin
    find_member.create_tin(number: tin_number)
end