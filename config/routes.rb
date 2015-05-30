Rails.application.routes.draw do
  resources :repositories, only: [:create, :show, :destroy] do
    resources :users, only: [:show], controller: 'repositories/users' do
      resource :owner, only: :create, controller: 'repositories/users/owners'
    end
  end

  resources :users, only: [:show, :create, :destroy] do
    resources :keys, only: :create, controller: 'users/keys'
    resource :link, only: [:create, :destroy], controller: 'users/links'
  end
end
