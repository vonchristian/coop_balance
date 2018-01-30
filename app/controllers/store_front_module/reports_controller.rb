module StoreFrontModule
  class ReportsController < ApplicationController
    def index
      @products = Product.all
    end
  end
end
