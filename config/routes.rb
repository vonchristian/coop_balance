Rails.application.routes.draw do
  mount Delayed::Web::Engine, at: '/jobs'
  # devise_for :committee_members
  unauthenticated :user do
    root :to => 'accounting_module#index', :constraints => lambda { |request| request.env['warden'].user.nil? }, as: :unauthenticated_root
  end
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: "management_module/settings/employees"}
  root :to => 'treasury_module#index', :constraints => lambda { |request| request.env['warden'].user.role == 'treasurer' if request.env['warden'].user }, as: :treasury_root
  root :to => 'accounting_module#index', :constraints => lambda { |request| request.env['warden'].user.role == 'bookkeeper' if request.env['warden'].user }, as: :accounting_module_root
  root :to => 'loans_module#index', :constraints => lambda { |request| request.env['warden'].user.role == 'loan_officer' if request.env['warden'].user }, as: :loans_module_root
  root :to => 'management_module#index', :constraints => lambda { |request| request.env['warden'].user.role == 'manager' if request.env['warden'].user }, as: :management_module_root
  root :to => 'teller_module#index', :constraints => lambda { |request| request.env['warden'].user.role == 'teller' if request.env['warden'].user }, as: :teller_module_root
  root :to => 'warehouse_module#index', :constraints => lambda { |request| request.env['warden'].user.role == 'stock_custodian' if request.env['warden'].user }, as: :warehouse_module_root
  root :to => 'store#index', :constraints => lambda { |request| request.env['warden'].user.role == 'sales_clerk' if request.env['warden'].user }, as: :store_module_root
  root :to => 'store#index', :constraints => lambda { |request| request.env['warden'].user.role == 'stock_custodian' if request.env['warden'].user }, as: :store_stocks_module_root
  root :to => 'hr_module#index', :constraints => lambda { |request| request.env['warden'].user.role == 'human_resource_officer' if request.env['warden'].user }, as: :hr_module_root 
  
   
  
  get "avatar/:size/:background/:text" => Dragonfly.app.endpoint { |params, app|
    app.generate(:initial_avatar, URI.unescape(params[:text]), { size: params[:size], background_color: params[:background] })
  }, as: :avatar
  get 'reports/balance_sheet' => 'reports#balance_sheet'
  get 'reports/income_statement' => 'reports#income_statement'
 
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
    resources :aging_loans, only: [:index, :show]
    resources :loan_calculator, only: [:index]
    resources :loan_applications, only: [:new, :create, :show, :edit, :update]
    resources :dashboard, only: [:index]
    resources :loan_products, except:[:destroy] do 
      resources :applications, only: [:new, :create]
    end
    resources :adjustments, only: [:destroy]
    resources :loan_charges, shallow: true do 
      resources :adjustments, only: [:new, :create], module: :loan_charges
    end
    resources :loans, except: [:destroy] do
    resources :first_notices, only: [:new, :create]
    resources :processings, only: [:create]
    resources :additional_charges, only: [:new, :create]
    resources :payments, only: [:new, :create]
    
    end
    resources :members, only: [:index, :show] do
      resources :loan_applications, only: [:new, :create], module: :member_loans
      resources :real_properties, only: [:new, :create]
    end
    resources :settings, only: [:index]
    resources :charges, only: [:new, :create]
    resources :loan_product_charges, only: [:new, :create]
    resources :loan_calculator, only: [:index]
    resources :schedules, only: [:index, :show]
    resources :notices, only: [:index, :show]

  end
  resources :share_capitals do
    resources :capital_build_ups, only: [:new, :create], module: :share_capitals
  end
  resources :members do
    resources :address_details
    resources :info, only: [:index], module: :members
    resources :loans, only: [:index, :new, :create], module: :members
    resources :real_properties, only: [:index, :new, :create], module: :members
    resources :share_capitals, only: [:index, :new, :create], module: :members
    resources :occupations, only: [:new, :create], module: :members
    resources :share_capitals, only: [:index, :new, :create]
    resources :savings_accounts, only: [:index, :new, :create], module: :members
    resources :time_deposits, only: [:index, :new, :create], module: :members
    resources :subscriptions, only: [:index], module: :members
    resources :subscription_payments, only: [:new, :create], module: :members #pay all subscriptions
    resources :purchases, only: [:index, :show], module: :members
  end
  resources :member_registrations, only: [:new, :create]

  resources :management_module, only: [:index]
  namespace :management_module do
    resources :accounting, only: [:index]
    resources :share_capitals, only: [:index, :show]
    resources :employees, only: [:index, :show]
    resources :savings, only: [:index, :show]
    resources :time_deposits, only: [:index, :show]
    resources :entries, only: [:index, :show]
    resources :accounts, only: [:index, :show]
    resources :employees, only: [:new, :create], module: :settings
    resources :share_capital_products, only: [:new, :create], module: :settings
    resources :saving_products, only: [:new, :create], module: :settings
    resources :programs, only: [:new, :create], module: :settings
    resources :time_deposit_products, only: [:new, :create], module: :settings
    resources :settings, only: [:index]
    resources :members, only: [:index, :show, :new, :create] do
      collection { post :import }
      end 
    resources :grace_periods, only: [:new, :create], module: :settings
    resources :loan_penalty_configs, only: [:new, :create], module: :settings
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
    
    resources :share_capitals, only: [:index, :show] do
      resources :capital_build_ups, only: [:new, :create]
    end
    resources :savings_accounts, only: [:index, :show] do
      resources :deposits, only: [:new, :create], module: :savings_accounts
      resources :withdrawals, only: [:new, :create], module: :savings_accounts
    end
    resources :time_deposits, only: [:index, :show] do
    end
    resources :entries, only: [:index, :show]
  end

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
    resources :search_results, only: [:index]
    resources :members, only: [:index, :show, :new, :create]
    resources :orders, only: [:index, :new, :create, :show]
    resources :line_items, only: [:new, :create]
    resources :stocks, only: [:index, :show]
    resources :products, only: [:index, :show, :new, :create] do
      resources :stocks, only: [:new, :create]
    end
  end
 
  resources :schedules, only: [:index, :show]
  resources :treasury_module, only: [:index]
  namespace :treasury_module do 
    resources :employees, only: [:index, :show] do 
      resources :remittances, only: [:new, :create]
    end
    resources :search_results, only: [:index]
    resources :savings_accounts, only: [:index, :show] do 
      resources :deposits, only: [:new, :create]
    end
    resources :entries, only: [:index, :show]
  end
  resources :savings_accounts, only: [:index, :show] do 
    resources :deposits, only: [:new, :create], module: :savings_accounts
    resources :withdrawals, only: [:new, :create], module: :savings_accounts
  end
  resources :search_results, only: [:index, :show]
  resources :occupations, only: [:index, :show]
  resources :disbursements, only: [:index, :show, :new, :create]
  resources :collections, only: [:index, :show]
  resources :suppliers, only: [:index, :show, :new, :create, :edit, :update] do 
      resources :vouchers, only: [:index, :show, :new, :create], module: :suppliers
      resources :deliveries, only: [:index, :new, :create], module: :suppliers
      resources :amounts, only: [:create, :destroy], module: :suppliers
    end
  resources :registries, only: [:create]

  resources :programs, only: [:index, :show] do 
    resources :payments, only: [:new, :create], module: :programs
  end
  resources :time_deposits, only: [:index, :show] do 
    resources :withdrawals, only: [:new, :create], module: :time_deposits
    resources :renewals, only: [:new, :create], module: :time_deposits
  end
  resources :employees, only: [:index, :show, :edit, :update] do 
    resources :entries, only: [:index, :show], module: :employees
    resources :remittances, only: [:new, :create], module: :employees
    resources :vault_fund_transfers, only: [:new, :create], module: :employees
    resources :reports, only: [:index], module: :employees
    resources :vouchers, only: [:index, :new, :create], module: :employees
    resources :amounts, only: [:new, :create, :destroy], module: :employees
  end
  resources :loans, only: [:index, :show] do 
    resources :loan_co_makers, only: [:new, :create], module: :loans
    resources :approvals, only: [:new, :create], module: :loans
    resources :disbursements, only: [:new, :create, :index], module: :loans
    resources :disbursement_vouchers, only: [:new, :create, :show], module: :loans
  end
  resources :loan_co_makers, only: [:destroy]
  resources :vouchers, only: [:index, :show] do 
    resources :disbursements, only: [:new, :create], module: :vouchers
  end
  resources :products, only: [:new, :create]
  resources :voucher_amounts, only: [:destroy]
  resources :bank_accounts, only: [:index, :show, :new, :create, :edit, :update] do 
    resources :deposits, only: [:new, :create], module: :bank_accounts
    resources :withdrawals, only: [:new, :create], module: :bank_accounts
    resources :bank_charges, only: [:new, :create], module: :bank_accounts
    resources :bank_earned_interests, only: [:new, :create], module: :bank_accounts
  end
  resources :hr_module, only: [:index]
  namespace :hr_module do 
    resources :contributions, only: [:new, :create]
    resources :amounts, only: [:new, :create]
    resources :settings, only: [:index]
    resources :departments, only: [:new, :create, :edit, :update]
    resources :salary_grades, only: [:new, :create, :edit, :update]
    resources :employees, except: [:destroy] do
      resources :profile, only: [:index]
      resources :employee_salary_grades, only: [:new, :create, :edit, :update]
      resources :employee_departments, only: [:new, :create, :edit, :update]
      resources :payrolls, only: [:index]

    end
  end
  mount ActionCable.server => '/cable'

end
