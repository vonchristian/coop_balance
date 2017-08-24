Rails.application.routes.draw do
  devise_for :committee_members
  get "avatar/:size/:background/:text" => Dragonfly.app.endpoint { |params, app|
    app.generate(:initial_avatar, URI.unescape(params[:text]), { size: params[:size], background_color: params[:background] })
  }, as: :avatar
  get 'reports/balance_sheet' => 'reports#balance_sheet'
  get 'reports/income_statement' => 'reports#income_statement'
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: "bplo_section/settings/users"}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :home, only: [:index]
  namespace :admin do
    resources :settings, only: [:index]
    resources :departments, only: [:new, :create]
    resources :branches, only: [:new, :create]
  end
  resources :accounting_module, only: [:index]
  namespace :accounting_module do
    resources :accounts
    resources :entries
    resources :balance_sheet
    resources :income_statement


  end
  resources :loans_module, only: [:index]
  
  namespace :loans_module do
    resources :loan_calculator, only: [:index]
    resources :loan_applications, only: [:new, :create, :show, :edit, :update]
    resources :dashboard, only: [:index]
    resources :loan_products, except:[:destroy] do 
      resources :applications, only: [:new, :create]
    end
    resources :loan_charges, shallow: true do 
      resources :adjustments, only: [:new, :create], module: :loan_charges
    end
    resources :loans, except: [:destroy] do
    resources :processings, only: [:create]
    resources :additional_charges, only: [:new, :create]
    resources :approvals, only: [:new, :create]
    resources :disbursements, only: [:new, :create]
    resources :payments, only: [:new, :create]
    resources :loan_co_makers, only: [:new, :create]
    end
    resources :members, only: [:index, :show] do
      resources :loan_applications, only: [:new, :create], module: :member_loans
      resources :real_properties, only: [:new, :create]
    end
    resources :settings, only: [:index]
    resources :charges, only: [:new, :create]
    resources :loan_product_charges, only: [:new, :create]
    resources :loan_calculator, only: [:index]

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
  
  namespace :management_module do
    resources :accounting, only: [:index]
    resources :share_capitals, only: [:index, :show]
    resources :employees, only: [:index, :show]
    resources :savings, only: [:index, :show]
    resources :time_deposits, only: [:index, :show]
    resources :entries, only: [:index, :show]
    resources :accounts, only: [:index, :show]
    resources :share_capital_products, only: [:new, :create], module: :settings
    resources :saving_products, only: [:new, :create], module: :settings
    resources :programs, only: [:new, :create], module: :settings
    resources :time_deposit_products, only: [:new, :create], module: :settings
    resources :settings, only: [:index]
    resources :members, only: [:index, :show, :new, :create]
    resources :grace_periods, only: [:new, :create], module: :settings
  end
  resources :teller_module, only: [:index]
  namespace :teller_module do
    resources :program_subscriptions, shallow: true do 
      resources :payments, only: [:new, :create], module: :program_subscriptions
    end
    resources :members, only: [:index, :show, :new, :create] do 
      resources :savings, only: [:new, :create]
      resources :time_deposits, only: [:new, :create]
    end
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
    resources :time_deposits, only: [:index, :show] do
    end
    resources :entries, only: [:index, :show]
  end
  root :to => 'accounting_modulet#index', :constraints => lambda { |request| request.env['warden'].user.role == 'accounting_officer' if request.env['warden'].user }, as: :accounting_module_root
  root :to => 'loans_module#index', :constraints => lambda { |request| request.env['warden'].user.role == 'loan_officer' if request.env['warden'].user }, as: :loans_module_root
  root :to => 'management_module#index', :constraints => lambda { |request| request.env['warden'].user.role == 'general_manager' if request.env['warden'].user }, as: :management_module_root
  root :to => 'teller_module#index', :constraints => lambda { |request| request.env['warden'].user.role == 'teller' if request.env['warden'].user }, as: :teller_module_root
  root :to => 'warehouse_module#index', :constraints => lambda { |request| request.env['warden'].user.role == 'stock_custodian' if request.env['warden'].user }, as: :warehouse_module_root
  root :to => 'store#index', :constraints => lambda { |request| request.env['warden'].user.role == 'store_cashier' if request.env['warden'].user }, as: :store_module_root
  root :to => 'store#index', :constraints => lambda { |request| request.env['warden'].user.role == 'stock_custodian' if request.env['warden'].user }, as: :store_stocks_module_root


  resources :users, only: [:show]
  resources :warehouse_module, only: [:index]

  namespace :warehouse_module do
    resources :balance_sheet, only: [:index]
    resources :income_statement, only: [:index]
    resources :suppliers, only: [:index, :show, :new, :create]
    resources :laborers, only: [:index, :show, :new, :create] do
      resources :days_worked, only: [:new, :create]
    end
    resources :purchases, only: [:index, :new, :create]
    resources :finished_goods, only: [:index, :new, :create]
    resources :raw_materials, only: [:index, :show, :new, :create] do
      resources :purchases, only: [:new, :create]
      resources :work_in_process_materials, only: [:new, :create]
      resources :finished_goods_materials, only: [:new, :create]
    end
  end
  resources :store, only: [:index]
  namespace :store_module do 
    resources :members, only: [:index, :show, :new, :create]
    resources :orders, only: [:index, :new, :create, :show]
    resources :line_items, only: [:new, :create]
    resources :products, only: [:index, :show, :new, :create] do
      resources :stocks, only: [:new, :create]
    end
  end
  unauthenticated :user do
    root :to => 'home#index', :constraints => lambda { |request| request.env['warden'].user.nil? }, as: :unauthenticated_root
  end
  mount ActionCable.server => '/cable'
end
