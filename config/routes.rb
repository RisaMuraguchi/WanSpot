Rails.application.routes.draw do

  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
}

  devise_for :users, skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}

  # ゲストログイン用
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  # 管理者側
  namespace :admin do
    resources :users, only: [:index, :show, :edit, :update]
    resources :posts, param: :user_id, only: [:show, :destroy]
  end

  # エンドユーザー
  root :to =>"homes#top"

  resources :posts do
    resources :comments, only: [:create, :destroy]
    resource :likes, only: [:create, :destroy]
  end

  get '/search', to: 'searches#search'
  get '/post/hashtag/:name', to: "posts#hashtag"
  get '/post/map', to: "posts#map"

  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
    member do
      get 'likes'
    end
  end


end
