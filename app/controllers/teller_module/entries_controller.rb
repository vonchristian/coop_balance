module TellerModule
  class EntriesController < ApplicationController
    def index
      @entries = current_user.entries
    end
  end
end
