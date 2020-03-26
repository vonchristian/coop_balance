module Cooperatives 
  class CooperativeBankingAgent < ApplicationRecord
    belongs_to :cooperative
    belongs_to :banking_agent
  end
end 