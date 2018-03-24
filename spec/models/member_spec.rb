require 'rails_helper'

describe Member, type: :model do
  describe "associations" do
    it { is_expected.to have_one :tin }
    it { is_expected.to belong_to :office }
    it { is_expected.to have_many :memberships }
  	it { is_expected.to have_many :loans }
  	it { is_expected.to have_many :addresses }
  	it { is_expected.to have_many :savings }
  	it { is_expected.to have_many :share_capitals }
  	it { is_expected.to have_many :time_deposits }
  	it { is_expected.to have_many :program_subscriptions }
  	it { is_expected.to have_many :subscribed_programs }
    it { is_expected.to have_many :sales_orders }
    it { is_expected.to have_many :sales_return_orders }
    it { is_expected.to have_many :real_properties }
    it { is_expected.to have_many :organization_memberships }
    it { is_expected.to have_many :organizations }
    it { is_expected.to have_many :relationships }
    it { is_expected.to have_many :relations }
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

  it ".has_birthdays_on(month)" do
    january = create(:member, date_of_birth: '01/01/1990')
    march = create(:member, date_of_birth: '01/03/1990')

    expect(Member.has_birthdays_on(1).pluck(:id)).to include(january.id)
    expect(Member.has_birthdays_on(3).pluck(:id)).to include(march.id)
  end

end
