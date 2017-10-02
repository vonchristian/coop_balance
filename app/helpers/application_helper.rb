module ApplicationHelper
  def root_path
    if user_signed_in?
      store_index_url
    else
      unauthenticated_root_path
    end
  end

  def root_url
    if user_signed_in?
      authenticated_root_url
    else
      unauthenticated_root_url
    end
  end
end
