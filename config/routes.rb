Rails.application.routes.draw do
  resources :sightings
  resources :animals
  get 'sightings/:start_date/:end_date' => "sightings#index"
end
