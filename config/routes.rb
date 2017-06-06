Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' , registrations: "bplo_section/settings/users"}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :admin do
    resources :settings, only: [:index]
    resources :departments, only: [:new, :create]
    resources :branches, only: [:new, :create]
  end
  namespace :accounting_department do
    resources :accounts
  end
  unauthenticated :user do
    root :to => 'users/sessions#new', :constraints => lambda { |request| request.env['warden'].user.nil? }, as: :unauthenticated_root
  end

  root :to => 'accounting_department#index', :constraints => lambda { |request| request.env['warden'].user.role == 'accounting_officer' if request.env['warden'].user }, as: :accounting_root

end
