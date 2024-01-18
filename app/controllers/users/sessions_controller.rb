class Users::SessionsController < Devise::SessionsController
  layout 'signin'

  def destroy
    super do
      # Turbo requires redirects be :see_other (303); so override Devise default (302)
      return redirect_to after_sign_out_path_for(resource_name), status: :see_other
    end
  end
end
