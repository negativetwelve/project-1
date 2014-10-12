Rails.application.routes.draw do
  get 'users/new'
  get 'users/:id', to: 'users#show', as: :user

  root to: "pages#home"

  # YOUR CODE HERE
  get "signup", to: "users#new"
  post "signup", to: "users#create", as: :users
  # END
end
