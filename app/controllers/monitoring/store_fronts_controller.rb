module Monitoring
  class StoreFrontsController < ApplicationController
    def index
      @store_fronts = current_user.cooperative.store_fronts
    end
  end
end
