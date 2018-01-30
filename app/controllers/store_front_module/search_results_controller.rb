module StoreFrontModule
  class SearchResultsController < ApplicationController
    def index
      @search_results = PgSearch.multisearch(params[:search])
    end
  end
end
