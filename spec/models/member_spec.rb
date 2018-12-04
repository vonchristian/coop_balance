require 'rails_helper'

describe Member, type: :model do
  describe "associations" do
    it { is_expected.to have_many :tins }
    it { is_expected.to belong_to :office }
    it { is_expected.to have_many :memberships }
  	it { is_expected.to have_many :loans }
  	it { is_expected.to have_many :savings }
  	it { is_expected.to have_many :share_capitals }
  	it { is_expected.to have_many :time_deposits }
  	it { is_expected.to have_many :program_subscriptions }
  	it { is_expected.to have_many :subscribed_programs }
    it { is_expected.to have_many :sales_orders }
    it { is_expected.to have_many :sales_return_orders }
    it { is_expected.to have_many :organization_memberships }
    it { is_expected.to have_many :organizations }
    it { is_expected.to have_many :contacts }
    it { is_expected.to have_many :addresses }
    it { is_expected.to have_many :beneficiaries }
    it { is_expected.to have_many :loan_applications }


  end
  describe 'delegations' do
    it { is_expected.to delegate_method(:name).to(:office).with_prefix }
  end

  describe 'validations' do
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

  it "#current_address" do
  end
  it "#subscribed?(program)" do
    member = create(:member)
    program1 = create(:program)
    program2 = create(:program)
    subscribed_program = create(:program_subscription, subscriber: member, program: program1)

    expect(member.subscribed?(program1)).to eql true
    expect(member.subscribed?(program2)).to eql false
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

  it '.with_tin' do
    member_with_tin    = create(:member)
    member_with_no_tin = create(:member)
    tin = create(:tin, tinable: member_with_tin)

    expect(described_class.with_tin).to include(member_with_tin)
    expect(described_class.with_tin).to_not include(member_with_no_tin)
  end

  it '.with_no_tin' do
    member_with_tin    = create(:member)
    member_with_no_tin = create(:member)
    tin = create(:tin, tinable: member_with_tin)

    expect(described_class.with_no_tin).to include(member_with_no_tin)
    expect(described_class.with_no_tin).to_not include(member_with_tin)
  end


end
