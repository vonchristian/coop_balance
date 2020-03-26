require 'rails_helper'

describe BankingAgent do
  describe "associations" do 
    it { is_expected.to belong_to :depository_account }
    it { is_expected.to have_many :cooperative_banking_agents }
    it { is_expected.to have_many :cooperatives }
    it { is_expected.to have_many :entries }
    it { is_expected.to have_many :recorded_entries }
  end

  describe "validations" do 
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :account_number }
    it  "is_expected.to validate_uniqueness_of :name " do 
      create(:banking_agent, name: "test")
      banking_agent = build(:banking_agent, name: "test")

      banking_agent.save 

      expect(banking_agent.errors[:name]).to eql ["has already been taken"]
    end 

    it  "is_expected.to validate_uniqueness_of :account_number " do 
      create(:banking_agent, account_number: "test")
      banking_agent = build(:banking_agent, account_number: "test")

      banking_agent.save 

      expect(banking_agent.errors[:account_number]).to eql ["has already been taken"]
    end 
  end 
end
