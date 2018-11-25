Rails.application.routes.draw do
  root "admin#index"
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # User
  get "/users", to: "user#index", as: :userIndex
  get "/users(/:id)", to: "user#detail", as: :userDetail
  delete "/users(/:id)", to: "user#delete", as: :userDelete
  get "/users-add", to: "user#add", as: :userAdd
  post "/users-add-process", to: "user#addProcess", as: :userAddProcess
  get "/users/update(/:id)", to: "user#update", as: :userUpdate
  post "/users/update-process", to: "user#updateProcess", as: :userUpdateProcess
  get "/users-datatable", to: "user#datatable", as: :userDatatable
  # Role
  get "/roles", to: "role#index", as: :roleIndex
  get "/role(/:id)", to: "role#detail", as: :roleDetail
  get "/role-add", to: "role#add", as: :roleAdd
  delete "/role(/:id)", to: "role#delete", as: :roleDelete
  post "/role-add-process", to: "role#addProcess", as: :roleAddProcess
  get "/role/update(/:id)", to: "role#update", as: :roleUpdate
  post "/role/update-process", to: "role#updateProcess", as: :roleUpdateProcess
  get "/roles-datatable", to: "role#datatable", as: :roleDatatable
end
