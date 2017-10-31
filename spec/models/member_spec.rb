require 'rails_helper'

describe Member, type: :model do
  describe "associations" do
    it { is_expected.to have_one :tin }
    it { is_expected.to have_one :membership }
  	it { is_expected.to have_many :loans }
  	it { is_expected.to have_many :addresses }
  	it { is_expected.to have_many :savings }
  	it { is_expected.to have_many :share_capitals }
  	it { is_expected.to have_many :time_deposits }
  	it { is_expected.to have_many :program_subscriptions }
  	it { is_expected.to have_many :programs }
    it { is_expected.to have_many :orders }
    it { is_expected.to have_many :real_properties }
    it { is_expected.to have_many :organization_memberships }
    it { is_expected.to have_many :organizations }


  end
  describe 'delegations' do
    it { is_expected.to delegate_method(:membership_type).to(:membership) }
  end

  describe 'validations' do
  end
  it "#full_name" do
  	member = create(:member, first_name: "Von", middle_name: "Pinosan", last_name: "Halip")

  	expect(member.full_name).to eql("Halip, Von P.")
  end
  it "#first_and_name" do
  	member = create(:member, first_name: "Von", middle_name: "Pinosan", last_name: "Halip")

  	expect(member.first_and_last_name).to eql("Von Halip")
  end
  it "#avatar_text" do
  	member = create(:member, first_name: "Von", middle_name: "Pinosan", last_name: "Halip")

  	expect(member.avatar_text).to eql("V")
  end
  it "#current_address" do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
