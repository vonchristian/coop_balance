module LoansModule
  class SearchResultsController < ApplicationController
    def index
      @search_results = PgSearch::Model.multisearch(params[:search])
    end
  end
end
