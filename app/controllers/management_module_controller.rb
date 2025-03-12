class ManagementModuleController < ApplicationController
  def index
    authorize :management_module
  end
end
