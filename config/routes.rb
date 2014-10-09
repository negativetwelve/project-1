Rails.application.routes.draw do
  get 'users/new'

  root to: "pages#home"

  # YOUR CODE HERE
  get "signup", to: "users#new"
  # END
end
