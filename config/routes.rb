Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]
  resources :bands do
  	resources :albums, only: [:new]
  end

  resources :albums, except: [:index, :new] do
      resources :tracks, only: [:new]
  end
  
  resources :tracks, except: [:index, :new] do
    patch '/find_lyrics', to: 'tracks#find_lyrics'
  end
end
