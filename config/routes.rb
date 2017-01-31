Rails.application.routes.draw do
  get '/', to: 'meetup#home'
  get '/auth/meetup/callback', to: 'meetup#callback'
  get '/events', to: 'meetup#events'
  get '/events/:urlname/:event_id', to: 'meetup#event'
  get '/events/:urlname/:event_id/random', to: 'meetup#people_random'
end
