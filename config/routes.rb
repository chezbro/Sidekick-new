Rails.application.routes.draw do
  root 'users#new'

  resources :users, only: %i[new create]
  resources :sessions, only: %i[new create destroy]

  resources :conversations, only: %i[index new show create] do
    resources :messages, only: %i[index new create]
  end

  # post 'twilio/voice' => 'twilio#voice'
  # post 'twilio/sms' => 'twilio#sms'

  get 'signup' => 'users#new'
  get 'login' => 'sessions#new'
  get 'logout' => 'sessions#destroy'

  get 'confirm' => 'users#confirm'
  post 'confirm' => 'users#verify'

  resources :confirmations, only: [:new, :create]

  post 'incoming_sms', to: 'messages#incoming_sms'
  # other routes...
end
