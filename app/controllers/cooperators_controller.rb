class CooperatorsController < ApplicationController
  layout 'cooperator'
  def show
    @cooperator = current_cooperator
  end
end
