class HomeController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  layout 'signin'
  def index
  end
end
