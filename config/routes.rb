Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'management_module/settings/employees' }

  authenticated :user do
    root to: 'members#index', as: :authenticated_root
  end

  resources :home, only: [:index]
  resources :accounting_module, only: [:index]
  namespace :accounting_module do
    resources :ledgers, only: %i[index show]
    resources :loan_products, only: [:show]
    resources :level_two_account_categories, only: %i[index show new create edit update], module: :account_categories do
      resources :settings, only: [:index], module: :level_two_account_categories
    end
    resources :level_three_account_categories, only: %i[index show new create edit update], module: :account_categories do
      resources :settings, only: [:index], module: :level_three_account_categories
    end
    resources :cooperative_services, only: [:show] do
      resources :entries, only: [:index], module: :cooperative_services
      resources :accounts, only: %i[index new create], module: :cooperative_services
    end
    resources :settings, only: [:index]

    resources :amounts, only: [:destroy]
    resources :commercial_document_adjusting_entry_line_items, only: %i[new create destroy], module: :entries
    resources :per_employee_entries, only: [:index], module: :entries
    resources :per_office_entries, only: [:index], module: :entries
    resources :scheduled_entries, only: [:index]
    resources :interest_expense_vouchers, only: [:show]
    resources :ioc_distributions, only: [:index]

    namespace :ioc_distributions do
      resources :loans,                      only: %i[new destroy]
      resources :loan_vouchers,              only: %i[create show destroy]
      resources :loan_voucher_confirmations, only: %i[create show]
      resources :loan_processings,           only: %i[new create]
      resources :share_capitals,             only: %i[new create destroy]
      resources :share_capital_vouchers,     only: %i[create show destroy]
      resources :share_capital_processings,  only: %i[new create]
      resources :savings,                    only: %i[new create destroy]
      resources :saving_processings,         only: %i[new create]
      resources :saving_vouchers,            only: %i[create show destroy]
      resources :program_subscriptions,      only: %i[new create]
    end
    namespace :scheduled_entries do
      resources :savings_accounts_interest_postings, only: %i[new create]
      resources :share_capital_dividend_postings, only: %i[new create]
      resources :loan_agings,       only: [:index]
      resources :book_closings,     only: %i[index new create]
      resources :book_closing_confirmations, only: [:show]
    end

    namespace :cash_books do
      resources :cash_receipts,                       only: [:index]
      resources :cash_disbursements,                  only: [:index]
    end

    resources :cash_receipts, module: :entries, only: [:index]
    resources :cash_disbursements, module: :entries, only: [:index]
    resources :journal_entry_vouchers, module: :entries, only: [:index]

    resources :entry_line_item_vouchers, only: %i[create show destroy], module: :entries do
      resources :confirmations, only: [:create], module: :entry_line_item_vouchers
    end

    resources :interests_earned_postings, only: [:create]
    resources :entry_line_items, only: %i[new create destroy]
    resources :entry_processings, only: [:create]
    resources :financial_condition_comparisons, only: %i[new create show]
    resources :reports, only: [:index]

    namespace :reports do
      namespace :cashbooks do
        resources :cash_receipts,      only: [:index]
        resources :cash_disbursements, only: [:index]
      end
      resources :trial_balances,           only: [:index]
      resources :proofsheets,              only: [:index]
      resources :income_statements,        only: [:index]
      resources :balance_sheets,           only: [:index]
      resources :statement_of_operations,  only: [:index]
    end

    resources :settings, only: [:index]

    resources :accounts, except: [:destroy] do
      resources :activations, only: [:create], module: :accounts
      resources :deactivations, only: [:create], module: :accounts
      resources :reports, only: [:index], module: :accounts
      resources :settings, only: [:index], module: :accounts
      resources :entries, only: [:index], module: :accounts
      resources :debit_entries, only: [:index], module: :accounts
      resources :credit_entries, only: [:index], module: :accounts
    end

    resources :assets, controller: 'accounts', type: 'AccountingModule::Asset'

    resources :entries do
      resources :cancellations, only: %i[new create], module: :entries
      resources :reversal_vouchers, only: %i[new create show], module: :entries
      resources :reversal_voucher_confirmations, only: [:create], module: :entries
    end

    resources :debit_amounts, only: %i[edit update]
    resources :credit_amounts, only: %i[edit update]
  end

  resources :loans_module, only: [:index]

  namespace :loans_module do
    resources :loan_aging_groups, only: [:show] do
      resources :loans, only: [:index], module: :loan_aging_groups
    end
    resources :amortization_schedules, only: %i[index show]
    resources :amortization_schedule_date_filters, only: [:index]

    resources :organizations, only: %i[index show] do
      resources :loans, only: [:index], module: :organizations
      resources :reports, only: [:index], module: :organizations
    end

    resources :archived_loans, only: [:index]
    resources :disbursement_vouchers, only: [:create]

    namespace :monitoring do
      resources :metrics, only: [:index]
      resources :loan_agings, only: [:index]
    end

    resources :search_results, only: [:index]

    namespace :reports do
      resources :loan_releases, only: [:index]
      resources :loan_collections, only: [:index]
      resources :loan_agings, only: [:index]
      resources :loan_aging_summaries, only: [:index]

      resources :aging_loans, only: [:index]
    end

    resources :member_borrowers, only: %i[index show]
    resources :reports, only: [:index]
    resources :aging_loans, only: %i[index show]

    resources :loan_applications, only: %i[index new create show destroy] do
      resources :disbursements,                       only: %i[new create],                           module: :loan_applications
      resources :capital_build_ups,                   only: %i[new create],                           module: :loan_applications
      resources :savings_account_deposit_processings, only: %i[new create],                           module: :loan_applications
      resources :previous_loan_payment_processings,   only: %i[new create],                           module: :loan_applications
      resources :vouchers,                            only: %i[new create show destroy], module: :loan_applications
      resources :amortization_schedules,              only: [:index],                                  module: :loan_applications
      resources :voucher_confirmations,               only: [:create],                                 module: :loan_applications
      resources :loan_amounts,                        only: %i[new create], module: :loan_applications
      resources :voucher_amounts,                     only: %i[new create edit update destroy], module: :loan_applications
      resources :program_payments,                    only: %i[new create], module: :loan_applications
    end

    resources :dashboard, only: [:index]

    resources :loan_products, only: %i[index show] do
      resources :loans,             only: [:index], module: :loan_products
      resources :reports,           only: [:index], module: :loan_products
      resources :loan_aging_groups, only: %i[index show], module: :loan_products
    end

    resources :loans, only: %i[index show] do
      resources :restructure_vouchers, only: %i[new create], module: :loans
      resources :loss_vouchers, only: [:show], module: :loans
      resources :interests,  only: [:index], module: :loans
      resources :penalties,  only: [:index], module: :loans
      resources :accounting, only: [:index], module: :loans

      resources :payment_from_savings,                   only: [:new], module: :loans
      resources :payment_from_saving_processings,        only: %i[new create destroy], module: :loans
      resources :payment_from_share_capitals,            only: [:new], module: :loans
      resources :payment_from_share_capital_processings, only: %i[new create destroy],  module: :loans
      resources :payment_vouchers,                       only: %i[create show destroy], module: :loans
      resources :payment_voucher_confirmations,          only: [:create], module: :loans

      resources :co_makers,                      only: %i[new create], module: :loans
      resources :past_due_vouchers,              only: %i[new create show destroy], module: :loans
      resources :past_due_voucher_confirmations, only: [:create], module: :loans
      resources :organizations,                  only: %i[edit update],                 module: :loans
      resources :loan_penalty_discounts,         only: %i[new create],                  module: :loans
      resources :loan_interest_discounts,        only: %i[new create],                  module: :loans
      resources :archivings,                     only: [:create], module: :loans

      resources :terms,                         only: %i[new create], module: :loans
      resources :interest_postings,             only: %i[new create], module: :loans
      resources :penalty_postings,              only: %i[new create], module: :loans
      resources :interest_rebate_postings,      only: %i[new create], module: :loans
      resources :amortization_schedules,        only: [:index], module: :loans

      resources :payments,                      only: %i[new create], module: :loans
      resources :losses,                        only: %i[new create], module: :loans
      resources :tracking_numbers,              only: %i[edit update], module: :loans
    end
  end
  resources :share_capitals, only: %i[index show] do
    resources :accounting,                            only: [:index], module: :share_capitals
    resources :withdrawals,                           only: %i[new create], module: :share_capitals
    resources :withdrawal_vouchers,                   only: %i[show destroy], module: :share_capitals
    resources :withdrawal_voucher_confirmations,      only: [:create], module: :share_capitals
    resources :balance_transfer_processings,          only: %i[new create destroy], module: :share_capitals
    resources :balance_transfer_vouchers,             only: %i[new create], module: :share_capitals
    resources :voucher_confirmations,                 only: [:create], module: :share_capitals
    resources :vouchers, only: %i[show destroy], module: :share_capitals

    resources :barangays, only: %i[edit update], module: :share_capitals
    resources :settings, only: [:index],          module: :share_capitals
    resources :mergings, only: [:create],         module: :share_capitals
    resources :merging_line_items, only: %i[new create destroy], module: :share_capitals
    resources :capital_build_ups, only: %i[new create],  module: :share_capitals
    resources :account_closings, only: %i[new create],   module: :share_capitals
    resources :offices, only: %i[edit update],           module: :share_capitals
    resources :balance_transfers, only: [:new],           module: :share_capitals
    resources :transactions, only: [:index],              module: :share_capitals
    resources :beneficiaries, only: %i[edit update], module: :share_capitals
    resources :maf_beneficiaries, only: %i[edit update], module: :share_capitals
    resources :multiple_line_items, only: %i[new create destroy], module: :share_capitals
  end

  resources :members, only: %i[index show edit update destroy] do
    resources :bills_payments,        only: [:index], module: :members
    resources :organizations,         only: %i[new create], module: :members
    resources :beneficiaries,         only: %i[new create destroy], module: :members
    resources :merging_line_items,    only: %i[new create], module: :members
    resources :mergings,              only: [:create], module: :members
    resources :contacts,              only: %i[new create],                 module: :members
    resources :tins,                  only: %i[new create],                 module: :members
    resources :time_deposits,         only: %i[index new create], module: :members
    resources :tins,                  only: %i[new create],                 module: :members
    resources :offices,               only: %i[edit update],                module: :members
    resources :addresses,             only: %i[new create],                 module: :members
    resources :memberships,           only: %i[edit update new create], module: :members
    resources :info,                  only: [:index],                        module: :members
    resources :settings,              only: [:index],                        module: :members
    resources :loans,                 only: [:index],                        module: :members
    resources :share_capitals,        only: [:index],                        module: :members
    resources :savings_accounts,      only: [:index],                        module: :members
    resources :subscriptions,         only: [:index],                        module: :members
    resources :program_subscriptions, only: [:create],                       module: :members
    resources :sales,                 only: %i[index show], module: :members
    resources :credit_sales_line_items, only: %i[new create destroy], module: :members
    resources :account_mergings,      only: %i[new create], module: :members
    resources :signature_specimens,   only: [:create],                       module: :members
    resources :avatars,               only: [:update],                       module: :members
    resources :retirements,           only: %i[edit update], module: :members
    resources :loan_transactions,     only: [:index], module: :members
  end

  resources :member_registrations, only: %i[new create]
  resources :organization_registries, only: %i[new create], module: [:registries]
  resources :savings_account_registries, only: [:create],    module: [:registries]
  resources :share_capital_registries, only: [:create],      module: [:registries]
  resources :loan_registries, only: [:create],               module: [:registries]
  resources :time_deposit_registries, only: [:create],       module: [:registries]
  resources :member_registries, only: [:create],             module: [:registries]
  resources :bank_account_registries, only: [:create],       module: [:registries]
  resources :program_subscription_registries, only: [:create],       module: [:registries]

  namespace :management_module do
    resources :account_budgets, only: %i[index new create]
    resources :loan_protection_plan_providers, only: %i[new create], module: :configurations

    namespace :settings do
      resources :general, only: [:index]
      resources :offices, only: [:index]
      resources :saving_products, only: [:index]
      resources :share_capital_products, only: [:index]
      resources :time_deposit_products, only: [:index]
      resources :programs, only: [:index]
      resources :store_fronts, only: [:index]
      resources :cooperative_services, only: [:index]
      resources :account_budgets, only: [:index]
      resources :cooperative_products, only: [:index]
      resources :configurations, only: [:index]
      resources :data_migrations, only: [:index]
      resources :barangays, only: [:index]

      resources :loan_products, only: %i[index new create edit update] do
        resources :charges, only: %i[new create edit update], module: :loan_products
        resources :interest_configurations, only: %i[new create], module: :loan_products
        resources :penalty_configurations, only: %i[new create],  module: :loan_products
        resources :deactivations, only: [:create],                 module: :loan_products
        resources :activations, only: [:create],                   module: :loan_products
      end

      resources :store_fronts, only: %i[new create]
      resources :net_income_distributions, only: %i[new create]

      resources :cooperatives, only: %i[edit update show] do
        resources :offices, only: %i[new create]
      end

      resources :time_deposit_products, only: %i[new create show edit update]
    end

    resources :employees, only: %i[index show]
    resources :employees, only: %i[new create], module: :settings

    resources :share_capital_products, only: %i[new create edit update], module: :settings do
      resources :shares, only: %i[new create]
    end

    resources :saving_products, only: %i[new create edit update], module: :settings
    resources :programs, only: %i[new create], module: :settings
    resources :settings, only: [:index]
    resources :grace_periods, only: %i[new create], module: :settings
  end

  resources :teller_module, only: [:index]
  resources :users, only: [:show]

  namespace :store_front_module do
    resources :stock_registry_processings, only: [:create]
    resources :stock_registries, only: %i[create show], module: :settings
    resources :suppliers, only: %i[index show new create] do
      resources :vouchers, only: %i[index show create destroy], module: :suppliers
      resources :voucher_confirmations, only: [:create], module: :suppliers
      resources :purchase_deliveries, only: %i[index new create], module: :suppliers
      resources :purchase_returns, only: %i[index new create], module: :suppliers
      resources :voucher_amounts, only: %i[new create destroy], module: :suppliers
      resources :purchase_line_items, only: %i[new create], module: :suppliers
    end

    resources :inventories, only: %i[index show] do
      resources :sales,            only: [:index], module: :inventories
      resources :sales_returns,    only: [:index], module: :inventories
      resources :purchase_returns, only: [:index], module: :inventories
      resources :spoilages,        only: [:index], module: :inventories
      resources :settings,         only: [:index], module: :inventories
      resources :internal_uses,    only: [:index], module: :inventories
      resources :stock_transfers,  only: [:index], module: :inventories
    end

    resources :purchase_orders,    only: %i[index show create], module: :orders
    resources :sales,              only: %i[index show create], module: :orders
    resources :credit_sales,       only: [:create], module: :orders
    resources :sales_returns,      only: %i[index show create], module: :orders
    resources :purchase_returns,   only: %i[index create],        module: :orders
    resources :spoilages,          only: %i[index create],        module: :orders
    resources :stock_transfers,    only: [:index], module: :orders

    resources :purchase_line_items,                only: %i[new create destroy], module: :line_items
    resources :sales_line_items,                   only: %i[new create destroy], module: :line_items
    resources :sales_return_line_items,            only: %i[new create destroy], module: :line_items
    resources :purchase_return_line_items,         only: %i[new create destroy], module: :line_items
    resources :credit_sales_line_items,            only: %i[new create destroy], module: :line_items
    resources :spoilage_line_items,                only: %i[new create destroy], module: :line_items
    resources :stock_transfer_line_items,          only: %i[new create destroy], module: :line_items
    resources :internal_use_line_items,            only: %i[new create destroy], module: :line_items
    resources :received_stock_transfer_line_items, only: %i[new create destroy], module: :line_items

    resources :sales_reports,             only: [:index], module: :reports
    resources :sales_clerk_reports,       only: [:index], module: :reports
    resources :sales_clerk_sales_reports, only: [:index], module: :reports
    resources :purchases_reports,         only: [:index], module: :reports
    resources :spoilages_reports,         only: [:index], module: :reports

    resources :employees,      only: [:show]
    resources :settings,       only: [:index]
    resources :reports, only: [:index]
    resources :search_results, only: [:index]

    resources :products, only: %i[index show new create] do
      resources :purchases,                only: %i[index new create], module: :products
      resources :sales,                    only: [:index],                module: :products
      resources :purchase_returns,         only: [:index],                module: :products
      resources :sales_returns,            only: [:index],                module: :products
      resources :settings,                 only: [:index],                module: :products
      resources :spoilages,                only: [:index],                module: :products
      resources :internal_uses,            only: [:index],                module: :products
      resources :stock_transfers,          only: [:index],                module: :products
      resources :received_stock_transfers, only: [:index],                module: :products
      resources :unit_of_measurements, only: %i[new create]
    end

    resources :unit_of_measurements, only: [:show] do
      resources :mark_up_prices, only: %i[new create]
    end

    resources :customers, only: %i[index show] do
      resources :sales_orders, only: [:index], module: :customers
    end
  end

  resources :schedules, only: %i[index show]
  resources :treasury_module, only: [:index]

  namespace :treasury_module do
    namespace :summaries do
      resources :cash_books, only: [:index]
      resources :loans, only: [:index]
    end
    resources :cash_accounts, only: %i[index show] do
      resources :daily_transactions,                        only: [:index],                  module: :cash_accounts
      resources :receipts,                                  only: [:index],                  module: :cash_accounts
      resources :disbursements,                             only: [:index],                  module: :cash_accounts
      resources :reports,                                   only: [:index],                  module: :cash_accounts
      resources :cash_receipt_line_items,                   only: %i[new create destroy], module: :cash_accounts
      resources :cash_disbursement_line_items,              only: %i[new create], module: :cash_accounts
      resources :cash_disbursement_line_item_cancellations, only: [:create],                 module: :cash_accounts
      resources :cash_disbursement_vouchers,                only: [:show],                   module: :cash_accounts
    end

    resources :disbursements, only: [:index]
    resources :cash_receipts, only: [:index]
    resources :cash_disbursement_voucher_processings, only: [:create]
    resources :cash_receipt_voucher_processings, only: [:create]

    resources :cash_disbursement_vouchers, only: %i[show destroy] do
      resources :confirmations, only: [:create], module: :cash_disbursement_vouchers
    end

    resources :cash_receipt_vouchers, only: %i[show destroy] do
      resources :confirmations, only: [:create], module: :cash_receipt_vouchers
    end
  end

  resources :savings_accounts_dashboards, only: [:index]
  resources :savings_accounts_below_minimum_balances, only: [:index]
  resources :share_capitals_below_minimum_balances, only: [:index]

  namespace :share_capitals_section do
    resources :dashboards, only: [:index]
  end

  resources :savings_accounts, only: %i[index show] do
    resources :accounting, only: [:index], module: :savings_accounts
    resources :balance_transfers, only: [:new], module: :savings_accounts
    resources :balance_transfer_processings, only: %i[new create destroy], module: :savings_accounts
    resources :balance_transfer_vouchers, only: [:show], module: :savings_accounts
    resources :deposit_vouchers, only: %i[show destroy],           module: :savings_accounts
    resources :withdrawal_vouchers, only: %i[show destroy],        module: :savings_accounts
    resources :account_closing_vouchers, only: %i[show destroy],   module: :savings_accounts
    resources :balance_transfers, only: %i[new create],            module: :savings_accounts
    resources :settings,          only: [:index],                   module: :savings_accounts
    resources :account_mergings,  only: [:create],                  module: :savings_accounts
    resources :merging_line_items, only: %i[new create destroy], module: :savings_accounts
    resources :deposits,          only: %i[new create],            module: :savings_accounts
    resources :withdrawals,       only: %i[new create],            module: :savings_accounts
    resources :account_closings,  only: %i[new create],            module: :savings_accounts
    resources :barangay_settings, only: %i[edit update], module: :savings_accounts
    resources :voucher_confirmations, only: [:create], module: :savings_accounts
    resources :transactions, only: [:index], module: :savings_accounts
    resources :beneficiaries, only: %i[edit update], module: :savings_accounts
    resources :multiple_line_items, only: %i[new create destroy], module: :savings_accounts
  end

  resources :search_results, only: %i[index show]

  resources :time_deposits, only: %i[index show] do
    resources :transfer_to_savings, only: %i[new create], module: :time_deposits
    resources :transfer_vouchers, only: %i[show destroy], module: :time_deposits do
      resources :confirmations, only: [:create], module: :transfer_vouchers
    end

    resources :withdrawal_vouchers, only: %i[show destroy], module: :time_deposits do
      resources :confirmations, only: [:create], module: :withdrawal_vouchers
    end

    resources :adjusting_entries, only: %i[new create],                  module: :time_deposits
    resources :withdrawals,       only: %i[new create],                  module: :time_deposits
    resources :partial_withdrawals, only: %i[new create], module: :time_deposits
    resources :term_extensions,   only: %i[new create],                  module: :time_deposits
    resources :break_contracts,   only: %i[new create],                  module: :time_deposits
    resources :settings,          only: [:index], module: :time_deposits
    resources :beneficiaries,     only: %i[edit update], module: :time_deposits
    resources :accounting,        only: [:index], module: :time_deposits
    resources :interest_postings, only: %i[new create show destroy], module: :time_deposits do
      resources :confirmations,   only: [:create], module: :interest_postings
    end
  end

  resources :employees, only: %i[index show edit update] do
    resources :cash_count_line_items, only: %i[new create], module: :employees
    resources :settings,             only: [:index], module: :employees
    resources :cash_accounts,        only: %i[new create destroy], module: :employees
    resources :store_fronts,         only: %i[edit update], module: %i[employees settings]
    resources :info,                 only: [:index],                        module: :employees
    resources :blotters,             only: [:index],                        module: :employees
    resources :cash_disbursements,   only: [:index],                        module: %i[employees reports]
    resources :cash_receipts,        only: [:index],                        module: %i[employees reports]
    resources :cash_book_transactions, only: [:index],                      module: %i[employees reports]
    resources :memberships,          only: %i[new create edit update], module: :employees
    resources :time_deposits,        only: [:index],                        module: :employees
    resources :savings_accounts,     only: [:index],                        module: :employees
    resources :share_capitals,       only: [:index],                        module: :employees
    resources :entries,              only: %i[index show],                 module: :employees
    resources :remittances,          only: %i[new create],                 module: :employees
    resources :cash_transfers,       only: %i[new create],                 module: :employees
    resources :vault_fund_transfers, only: %i[new create],                 module: :employees
    resources :reports,              only: [:index], module: :employees
    resources :vouchers,             only: %i[index new create],         module: :employees
    resources :amounts,              only: %i[new create destroy],       module: :employees
    resources :orders,               only: [:index],                        module: :employees
    resources :loans,                only: [:index],                        module: :employees
    resources :avatars,              only: [:update],                       module: :employees
    resources :accounts, only: %i[edit update], module: :employees
  end

  resources :loans, only: %i[index show] do
    resources :payment_vouchers,     only: [:show],                  module: :loans do
      resources :confirmations,      only: [:create],                module: :payment_vouchers
    end
    resources :notes,                 only: %i[index new create], module: :loans
    resources :purposes,              only: %i[edit update],        module: :loans
    resources :barangays,             only: %i[edit update],        module: :loans
    resources :settings,              only: [:index], module: :loans
    resources :payments,              only: %i[index new create], module: :loans
    resources :payment_with_iocs, only: %i[new create], module: :loans
  end

  namespace :loans_module do
    resources :loan_payments, only: [:show]
    resources :settings, only: [:index]
    namespace :settings do
      resources :archives,           only: %i[new create]
      resources :loan_aging_groups,  only: %i[new create show edit update] do
        resources :office_loan_products, only: %i[new create], module: :loan_aging_groups
      end
    end
  end

  resources :vouchers, only: %i[index show destroy] do
    resources :cancellations, only: [:create], module: :vouchers
    resources :disbursements, only: [:create], module: :vouchers
    resources :loan_disbursements, only: %i[new create], module: :vouchers
  end

  resources :bank_accounts, only: %i[index show new create] do
    resources :vouchers, only: %i[show destroy],            module: :bank_accounts
    resources :voucher_confirmations, only: [:create], module: :bank_accounts
    resources :deposits, only: %i[new create],              module: :bank_accounts
    resources :withdrawals, only: %i[new create],           module: :bank_accounts
    resources :settings, only: [:index], module: :bank_accounts
  end

  resources :organizations, only: %i[index show new create edit update] do
    resources :members, only: %i[index new create], module: :organizations
    resources :loans, only: [:index],            module: :organizations
    resources :reports, only: [:index],          module: :organizations
    resources :share_capitals, only: [:index],   module: :organizations
    resources :settings, only: [:index],         module: :organizations
    resources :savings_accounts, only: [:index], module: :organizations
  end

  resources :membership_applications, only: %i[new create]

  resources :cooperatives, only: [:show] do
    resources :barangays, only: %i[new create edit update], module: :cooperatives
    resources :logos, only: [:create], module: :cooperatives
  end

  resources :monitoring, only: [:index]
  namespace :monitoring do
    resources :share_capitals, only: [:index]
    resources :savings_products, only: [:index]
    resources :loan_products, only: [:index]
    resources :store_fronts, only: [:index]
  end

  resources :filtered_loans, only: [:index], module: :loans_module
  resources :matured_loans, only: [:index],  module: :loans_module

  resources :barangays, only: %i[index show new create edit update] do
    resources :loans, only: [:index],                  module: :barangays
    resources :savings, only: [:index],                module: :barangays
    resources :members, only: %i[index new create], module: :barangays
    resources :settings, only: [:index], module: :barangays
  end

  namespace :barangays do
    resources :imports, only: [:create]
  end

  resources :memberships, only: %i[index show] do
    resources :share_capital_subscriptions, only: %i[new create], module: :memberships
    resources :program_subscriptions, only: [:create], module: :memberships do
      resources :payments, only: %i[new create], module: :program_subscriptions
    end
  end

  namespace :cooperators do
    resources :accounts, only: [:show]
    resources :sign_ups, only: [:new]
  end

  resources :program_subscriptions, only: [:show] do
    resources :payments, only: %i[new create], module: :program_subscriptions
    resources :vouchers, only: [:show], module: :program_subscriptions
    resources :voucher_confirmations, only: [:create], module: :program_subscriptions
  end

  resources :metrics, only: [:index]
  namespace :metrics do
    resources :savings_accounts, only: %i[index create]
  end

  namespace :reports do
    resources :audit_reports, only: [:index]
  end

  resources :cooperative_services, only: %i[index new create show] do
    resources :entries, only: [:index], module: :cooperative_services
    resources :balance_sheets, only: [:index],        module: :cooperative_services
    resources :income_statements, only: [:index],     module: :cooperative_services
    resources :settings,        only: [:index], module: :cooperative_services
    resources :accounts,        only: %i[new create], module: :cooperative_services do
      resources :activations,   only: [:create],       module: :accounts
      resources :deactivations, only: [:create],       module: :accounts
    end
  end

  namespace :coop_module do
    resources :search_results, only: [:index]
  end

  resources :time_deposit_applications, only: %i[new create] do
    resources :vouchers, only: %i[show destroy], module: :time_deposit_applications
    resources :voucher_confirmations, only: [:create], module: :time_deposit_applications
  end

  resources :time_deposit_application_calculators, only: %i[new create], module: :time_deposits do
    resources :vouchers, only: %i[show destroy], module: :time_deposit_applications
    resources :voucher_confirmations, only: [:create], module: :time_deposit_applications
  end

  resources :savings_account_applications, only: %i[new create] do
    resources :vouchers, only: %i[show destroy], module: :savings_account_applications
    resources :voucher_confirmations, only: [:create], module: :savings_account_applications
  end

  resources :share_capital_applications, only: %i[new create] do
    resources :vouchers, only: %i[show destroy],      module: :share_capital_applications
    resources :voucher_disbursements, only: [:create], module: :share_capital_applications
  end

  resources :portfolios, only: [:index]

  namespace :portfolios do
    resources :savings, only: [:index]
    resources :averaged_daily_balance_savings, only: [:index]

    resources :share_capitals, only: [:index]
    resources :averaged_daily_balance_share_capitals, only: [:index]

    resources :time_deposits,  only: [:index]
    resources :loans,          only: [:index]
  end

  unauthenticated :user do
    root to: 'home#index', constraints: ->(request) { request.env['warden'].user.nil? }, as: :unauthenticated_root
  end

  resources :bank_account_applications, only: %i[new create]
  mount ActionCable.server => '/cable'
  namespace :portfolios do
    resources :loans, only: [:index]
  end

  resources :offices, only: %i[index show] do
    resources :loans,                  only: [:index],                module: :offices
    resources :savings_accounts,       only: [:index],                module: :offices
    resources :share_capitals,         only: [:index],                module: :offices
    resources :time_deposits,          only: [:index],                module: :offices
    resources :entries,                only: [:index],                module: :offices
    resources :reports,                only: [:index],                module: :offices
    resources :settings,               only: [:index],                module: :offices
    resources :programs,               only: %i[index new create], module: :offices
    resources :saving_products,        only: %i[index new create], module: :offices
    resources :loan_products,          only: %i[index new create], module: :offices
    resources :share_capital_products, only: %i[index new create], module: :offices
    resources :time_deposit_products,  only: %i[index new create], module: :offices
    resources :net_income_configs,     only: %i[index new create], module: :offices
  end
  resources :program_subscriptions, only: [:show]
  resources :identifications, only: %i[index show new create], module: :identification_module
  resources :multiple_transactions, only: %i[new create]
  resources :loan_multiple_payment_line_items, only: %i[new create destroy]
  resources :multiple_loan_payment_processings, only: [:create]
  resources :multiple_loan_payment_vouchers, only: [:show] do
    resources :confirmations, only: [:create], module: %i[loans_module loan_multiple_transactions]
  end
  resources :loans, only: [:show] do
    resources :multiple_payments, only: %i[new create destroy], module: :loans
  end
  resources :carts, only: [:destroy]

  resources :share_capital_multiple_transactions, only: [:new], module: :share_capitals
  resources :share_capital_multiple_transaction_processings, only: [:create], module: :share_capitals
  resources :share_capital_multiple_transaction_vouchers, only: %i[show destroy], module: :share_capitals do
    resources :confirmations, only: [:create], module: :share_capital_multiple_transactions
  end

  resources :savings_account_multiple_transactions, only: [:new], module: :savings_accounts
  resources :savings_account_multiple_transaction_processings, only: [:create], module: :savings_accounts
  resources :savings_account_multiple_transaction_vouchers, only: %i[show destroy], module: :savings_accounts do
    resources :confirmations, only: [:create], module: :savings_account_multiple_transactions
  end
end
