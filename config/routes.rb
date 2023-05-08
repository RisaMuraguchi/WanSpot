Rails.application.routes.draw do

  # devise関係のルーティング後で直す
  devise_for :admins

  devise_for :users, skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}

  # ゲストログイン用
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  root :to =>"homes#top"

  resources :posts do
    resources :comments, only: [:create, :destroy]
    resource :likes, only: [:create, :destroy]
    collection do
      get 'search'
    end
  end

  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end


end
