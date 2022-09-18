Rails.application.routes.draw do
  resources :merchants, module: :merchant do
    resources :items
    resources :invoices, only: [:index]
  end

  resources :merchants do
    resources :dashboards, only: [:index, :create]
  end

  #get '/merchants/:id/items/:id', to: 'items#edit'
  resources :admin, only: [:index]
  namespace :admin do
    resources :invoices, except: [:new, :destroy]
    resources :merchants
  end
end
