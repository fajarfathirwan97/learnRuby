Rails.application.routes.draw do
  root "admin#index"
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/users", to: "user#index", as: :userIndex
  get "/users-datatable", to: "user#datatable", as: :userDatatable
end
