require 'will_paginate/array'
module AccountingModule
  module Entries
    class JournalEntryVouchersController < ApplicationController
      def index
        @entries = current_cooperative.entries.without_cash_accounts.paginate(page: params[:page],per_page: 25)
      end
    end
  end
end
