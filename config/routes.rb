Rails.application.routes.draw do
  root "admin#index"
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/users", to: "user#index", as: :userIndex
  get "/users(/:id)", to: "user#detail", as: :userDetail
  get "/users-add", to: "user#add", as: :userAdd
  post "/users-add-process", to: "user#addProcess", as: :userAddProcess
  get "/users/update(/:id)", to: "user#update", as: :userUpdate
  post "/users/update-process", to: "user#updateProcess", as: :userUpdateProcess
  get "/users-datatable", to: "user#datatable", as: :userDatatable
end
