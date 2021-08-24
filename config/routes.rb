Rails.application.routes.draw do
  devise_for :users
  root to: "homes#top"
  get "about" => "homes#about"
  resources :users, only:[:show,:edit,:update]
  resources :blogs do
    resource :favorites, only:[:create,:destroy]
    resources :blog_comments, only:[:create,:destroy]
  end
end
