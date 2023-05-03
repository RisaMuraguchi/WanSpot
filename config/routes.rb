Rails.application.routes.draw do
  get 'homes/top'
  get 'posts/new'
  get 'posts/index'
  get 'posts/show'
  get 'posts/edit'
  get 'users/show'
  get 'users/edit'
  get 'users/index'
  # devise関係のルーティング後で直す
  devise_for :admins
  devise_for :users
end
