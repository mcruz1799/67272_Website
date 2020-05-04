Rails.application.routes.draw do

  # Semi-static page routes
  get 'home', to: 'home#index', as: :home
  get 'home/about', to: 'home#about', as: :about
  get 'home/contact', to: 'home#contact', as: :contact
  get 'home/privacy', to: 'home#privacy', as: :privacy
  get 'home/search', to: 'home#search', as: :search

  # Searching routes
  get 'employees/search', to: 'employees#search', as: :employee_search

  # Resource routes (maps HTTP verbs to controller actions automatically):
  resources :employees
  resources :stores
  resources :assignments
  resources :shifts
  resources :pay_grades #TO DO: TAKE OUT UNNECESSARY ROUTES
  resources :pay_grade_rates #TO DO: SAME AS ABOVE
  resources :jobs #TO DO: SAME AS ABOVE
  resources :sessions, only: [:new, :create, :destroy]

  # Custom routes
  get 'login', to: 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout
  patch 'assignments/:id/terminate', to: 'assignments#terminate', as: :terminate_assignment
  get 'payroll/store_report/:id', to: 'payroll#generate_store_report', as: :generate_store_report
  get 'payroll/employee_report/:id', to: 'payroll#generate_employee_report', as: :generate_employee_report
  get 'schedule', to: 'schedules#schedule', as: :schedule
  post 'new_shift_job', to: 'shifts#create_shift_job', as: :new_shift_job

  # You can have the root of your site routed with 'root'
  root 'home#index'
end
