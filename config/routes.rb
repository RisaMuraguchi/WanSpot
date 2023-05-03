Rails.application.routes.draw do
  # devise関係のルーティング後で直す
  devise_for :admins
  devise_for :users
end
