Rails.application.routes.draw do
  root 'pages#dashboard'

  devise_for :users

  get "facebook/tokens/callback" => 'facebook_tokens#create', as: "facebook_token_redirect"
  get "facebook/tokens/delete" => 'facebook_tokens#delete', as: "facebook_token_delete"
  post "facebook/tokens/deauthorize" => 'facebook_tokens#deauthorize'
  resources :facebook_pages, path: 'facebook/pages', only: [:index, :show]
end
