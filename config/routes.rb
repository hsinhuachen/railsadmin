Rails.application.routes.draw do
  root 'welcome#index'

  resources :projects, only: [:index, :show]
  # get '/projects', to: 'projects#index'
  # get '/projects/:id', to: 'projects#show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
