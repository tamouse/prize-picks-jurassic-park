Rails.application.routes.draw do
  resources :dinosaurs do
    member do
      patch 'move'
      put   'move'
    end
  end
  resources :cages do
    resources :dinosaurs
    member do
      patch 'power_down'
      put   'power_down'
      patch 'power_up'
      put   'power_up'
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
