# Randsome Meetup

Tired of being lost when someone need to make a give it away in the meetups?

Your problems are over.

Randome Meetup will randomise a attendee of the selected Meetup for your.


## To run

You will need to have Ruby 2.3.1 installed.

Go to [this link](https://secure.meetup.com/pt-BR/meetup_api/oauth_consumers/) and get the keys necessary to consume the OAuth api.

1. Change the `meetup-key` to the one provided by meetup.com in the `.env.example` file.
1. Change the `secret-key` to the one provided by meetup.com just like before.
1. Rename `.env.example`  to `.env`.
1. Exec `bundler install`
1. Exec `bundle exec rails server`.
1. Enjoy your life.
