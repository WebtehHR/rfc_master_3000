RfcMaster3000::Application.routes.draw do
  resources :request_for_changes

  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
end