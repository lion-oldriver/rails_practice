Rails.application.routes.draw do
  devise_for :users
  get "about" => "homes#about"
  get "search" => "searches#search"
  resources :users, only:[:show,:edit,:update] do
    resource :relationships, only:[:create,:destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end
  resources :blogs do
    resource :favorites, only:[:create,:destroy]
    resources :blog_comments, only:[:create,:destroy]
  end
end
