# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :billables, only: :index

  # Defines the root path route ("/")
  root 'billables#index'
end
