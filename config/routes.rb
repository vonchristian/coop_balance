Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' , registrations: "bplo_section/settings/users"}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :home, only: [:index]
  namespace :admin do
    resources :settings, only: [:index]
    resources :departments, only: [:new, :create]
    resources :branches, only: [:new, :create]
  end
  resources :accounting_department, only: [:index]
  namespace :accounting_department do
    resources :accounts
  end
  resources :loans_department, only: [:index]
  namespace :loans_department do
    resources :loan_products
    resources :loans, except: [:destroy]
    resources :members, only: [:index, :show] do
      resources :loan_applications, only: [:new, :create]
    end
  end
  resources :share_capitals do
    resources :capital_build_ups, only: [:new, :create]
  end
  resources :members do
    resources :address_details
    resources :share_capitals, only: [:index, :new, :create]
  end
  resources :member_registrations, only: [:new, :create]
  unauthenticated :user do
    root :to => 'home#index', :constraints => lambda { |request| request.env['warden'].user.nil? }, as: :unauthenticated_root
  end
  namespace :management_department do
    resources :share_capital_products, only: [:new, :create], module: :settings
    resources :settings, only: [:index]
    resources :members, only: [:index, :show]

  end
  root :to => 'accounting_department#index', :constraints => lambda { |request| request.env['warden'].user.role == 'accounting_officer' if request.env['warden'].user }, as: :accounting_department_root
  root :to => 'loans_department#index', :constraints => lambda { |request| request.env['warden'].user.role == 'loan_officer' if request.env['warden'].user }, as: :loans_department_root
  root :to => 'management_department#index', :constraints => lambda { |request| request.env['warden'].user.role == 'general_manager' if request.env['warden'].user }, as: :management_department_root

end
