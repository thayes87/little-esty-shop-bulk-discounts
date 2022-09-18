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
    resources :invoices, only: [:index, :show, :update]
    resources :merchants, only: [:index, :show, :edit, :update]
  end
end
