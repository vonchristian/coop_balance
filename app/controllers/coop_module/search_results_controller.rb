module CoopModule
  class SearchResultsController < ApplicationController
    def index
      @search_results = PgSearch::Model.multisearch(params[:navbar_search]).paginate(page: params[:page], per_page: 25)
    end
  end
end
