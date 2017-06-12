Rails.application.routes.draw do
  get 'reports/balance_sheet' => 'reports#balance_sheet'
  get 'reports/income_statement' => 'reports#income_statement'
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
    resources :entries
    resources :balance_sheet
    resources :income_statement


  end
  resources :loans_department, only: [:index]
  namespace :loans_department do
    resources :loan_products
    resources :loans, except: [:destroy] do
      resources :approvals, only: [:new, :create]
      resources :disbursements, only: [:new, :create]

    end
    resources :members, only: [:index, :show] do
      resources :loan_applications, only: [:new, :create]
    end
  end
  resources :savings do
    resources :deposits, only: [:new, :create]
    resources :withdrawals, only: [:new, :create]

  end
  resources :share_capitals do
    resources :capital_build_ups, only: [:new, :create]
  end
  resources :members do
    resources :address_details
    resources :share_capitals, only: [:index, :new, :create]
    resources :savings, only: [:index, :new, :create]
    resources :time_deposits, only: [:index, :new, :create]


  end
  resources :member_registrations, only: [:new, :create]
  unauthenticated :user do
    root :to => 'home#index', :constraints => lambda { |request| request.env['warden'].user.nil? }, as: :unauthenticated_root
  end
  namespace :management_department do
    resources :share_capital_products, only: [:new, :create], module: :settings
    resources :saving_products, only: [:new, :create], module: :settings
    resources :time_deposit_products, only: [:new, :create], module: :settings
    resources :settings, only: [:index]
    resources :members, only: [:index, :show]
  end
  namespace :teller_department do
    resources :suppliers, only: [:index, :show] do
      resources :payments, only: [:new, :create]
    end
    resources :share_capitals, only: [:index, :show] do
      resources :capital_build_ups, only: [:new, :create]
    end
    resources :savings_accounts, only: [:index, :show] do
      resources :deposits, only: [:new, :create]
      resources :withdrawals, only: [:new, :create]
    end
    resources :entries, only: [:index, :show]
  end
  root :to => 'accounting_department#index', :constraints => lambda { |request| request.env['warden'].user.role == 'accounting_officer' if request.env['warden'].user }, as: :accounting_department_root
  root :to => 'loans_department#index', :constraints => lambda { |request| request.env['warden'].user.role == 'loan_officer' if request.env['warden'].user }, as: :loans_department_root
  root :to => 'management_department#index', :constraints => lambda { |request| request.env['warden'].user.role == 'general_manager' if request.env['warden'].user }, as: :management_department_root
  root :to => 'teller_department#index', :constraints => lambda { |request| request.env['warden'].user.role == 'teller' if request.env['warden'].user }, as: :teller_department_root
  root :to => 'warehouse_department#index', :constraints => lambda { |request| request.env['warden'].user.role == 'stock_custodian' if request.env['warden'].user }, as: :warehouse_department_root

  resources :users, only: [:show]
  resources :warehouse_department, only: [:index]
  namespace :warehouse_department do
    resources :purchases, only: [:index, :new, :create]
    resources :raw_materials, only: [:index, :show, :new, :create] do
      resources :purchases, only: [:new, :create]
      resources :work_in_progress_materials, only: [:new, :create]
      resources :finished_goods_materials, only: [:new, :create]
    end
  end
end
