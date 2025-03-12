# frozen_string_literal: true

module Offices
  class Ledger < ApplicationRecord
    self.table_name = "office_ledgers"
    belongs_to :office, class_name: "Cooperatives::Office"
    belongs_to :ledger, class_name: "AccountingModule::Ledger"

    validates :ledger_id, uniqueness: { scope: :office_id }
  end
end
