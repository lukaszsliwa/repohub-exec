Rails.application.routes.draw do
  resources :repositories, only: [:create, :show, :destroy] do
    resources :users, only: [:show], controller: 'repositories/users' do
      resource :owner, only: :create, controller: 'repositories/users/owners'
      resource :link, only: [:create, :destroy], controller: 'repositories/users/links'
    end
  end

  resources :users, only: :show do
    resources :keys, only: :create, controller: 'users/keys'
  end
end
