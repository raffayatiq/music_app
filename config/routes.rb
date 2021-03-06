Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => "sessions#new"
  resources :users, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]
  resources :artists do
  	resources :albums, only: [:new]
    post '/populate_albums', to: 'artists#populate_albums'
  end

  resources :albums, except: [:index, :new] do
      resources :tracks, only: [:new]
      patch '/find_youtube_playlist_id', to: 'albums#find_youtube_playlist_id'
      post '/populate_tracks_from_spotify_api', to: 'albums#populate_tracks_from_spotify_api'
  end
  
  resources :tracks, except: [:index, :new] do
    patch '/find_lyrics', to: 'tracks#find_lyrics'
    patch '/find_video_id', to: 'tracks#find_video_id'
  end
end
