Rails.application.routes.draw do
  get '/', to: 'meetup#home'
  get '/auth/meetup/callback', to: 'meetup#callback'
  get '/events', to: 'events#index'
  get '/events/:urlname/:event_id', to: 'events#show'
  get '/events/:urlname/:event_id/random', to: 'events#random_attendee'
end
