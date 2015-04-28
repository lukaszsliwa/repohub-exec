Rails.application.routes.draw do
  resources :repositories, only: [:show, :destroy] do
    resources :groups, only: [] do
      resources :users, only: [:show], controller: 'repositories/groups/users' do
        resource :owner, only: :create, controller: 'repositories/groups/users/owners'
      end
    end
    resources :users, only: [:show], controller: 'repositories/users' do
      resource :link, only: [:create, :destroy], controller: 'repositories/users/links'
    end
  end

  resources :groups, only: [:create, :destroy] do
    resources :users, only: [:show], controller: 'groups/users' do
      resource :link, only: [:create, :destroy], controller: 'groups/users/links'
    end
  end
end
