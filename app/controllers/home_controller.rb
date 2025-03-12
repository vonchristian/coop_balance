class HomeController < ApplicationController
  layout "signin"
  skip_before_action :authenticate_user!, only: [ :index ]
  def index; end
end
