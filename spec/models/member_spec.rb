require 'rails_helper'

describe Member, type: :model do
  describe "associations" do
    it { is_expected.to have_one :member_account }
    it { is_expected.to have_many :tins }
    it { is_expected.to have_many :memberships }
  	it { is_expected.to have_many :loans }
  	it { is_expected.to have_many :savings }
  	it { is_expected.to have_many :share_capitals }
  	it { is_expected.to have_many :time_deposits }
  	it { is_expected.to have_many :program_subscriptions }
  	it { is_expected.to have_many :subscribed_programs }
    it { is_expected.to have_many :sales }
    it { is_expected.to have_many :sales_returns }
    it { is_expected.to have_many :organization_memberships }
    it { is_expected.to have_many :organizations }
    it { is_expected.to have_many :contacts }
    it { is_expected.to have_many :beneficiaries }
    it { is_expected.to have_many :loan_applications }
    it { is_expected.to have_many :share_capital_applications }
    it { is_expected.to have_many :savings_account_applications }
    it { is_expected.to have_many :time_deposit_applications }
    it { is_expected.to have_many :identifications }

  end

  describe 'validations' do
  end

  it "#signatory_name" do
    member = build(:member, first_name: "Von", middle_name: "Pinosan", last_name: "Halip")
    expect(member.signatory_name).to eql 'Von P. Halip'
  end

  it "#full_name" do
  	member = build(:member, first_name: "Von", middle_name: "Pinosan", last_name: "Halip")

  	expect(member.full_name).to eql("Halip, Von Pinosan")
  end

  it "#name" do
    member = build(:member, first_name: "Von", middle_name: "Pinosan", last_name: "Halip")

    expect(member.name).to eql("Halip, Von Pinosan")
  end

  it "#first_and_name" do
  	member = create(:member, first_name: "Von", middle_name: "Pinosan", last_name: "Halip")

  	expect(member.first_and_last_name).to eql("Von Halip")
  end

  it ".has_birthday_on(args)" do
    january_member = create(:member, date_of_birth: '01/01/1990')
    march_member   = create(:member, date_of_birth: '03/01/1990')

    expect(described_class.has_birthday_on(birth_day: 1)).to include(january_member)
    expect(described_class.has_birthday_on(birth_day: 3)).to include(march_member)
  end

  it '.updated_at(args={})' do
    recent_member = create(:member, last_transaction_date: Date.today)
    old_member = create(:member, last_transaction_date: Date.today.last_month)

    expect(described_class.updated_at(from_date: Date.today, to_date: Date.today)).to include(recent_member)
    expect(described_class.updated_at(from_date: Date.today, to_date: Date.today)).to_not include(old_member)

    expect(described_class.updated_at(from_date: Date.today.last_month, to_date: Date.today.last_month)).to include(old_member)
    expect(described_class.updated_at(from_date: Date.today.last_month, to_date: Date.today.last_month)).to_not include(recent_member)
  end



  describe "#age" do
    it 'with age' do
      member = create(:member, date_of_birth: '02/12/1990')

      expect(member.age).to eql 28
    end

    it "with no age" do
      member = create(:member, date_of_birth: nil)

      expect(member.age).to eq "No Date of Birth Entered"
    end
  end


end
