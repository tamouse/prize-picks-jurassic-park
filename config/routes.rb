Rails.application.routes.draw do
  resources :dinosaurs
  resources :cages do
    resources :dinosaurs
    member do
      put 'power_down'
      put 'power_up'
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
