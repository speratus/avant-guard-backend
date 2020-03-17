# README
This application is the backend for [Avant Garde](https://github.com/speratus/avant-guard-frontend).
The driving game logic behind the application is run on the backend, so it is the most critical part of 
the application.

### Features
Here are a few of the things the backend is responsible for:

* Picking a new song for a game.
* Making Requests to the Last.fm API for song data.
* Calculating the obscurity value of the game.
* checking each answer against the correct answer.
* calculating the final score of the game.
* creating friendships between users.

## Installation and setup
You will need ruby version `2.6.1p33` to install and run the avant garde backend.
At the very least, you will need the ruby gem `bundler` to install all the requied
dependencies.
Additionally, you will need to have Postgresql installed and running on your machine.

1. Navigate to the directory where you want to save the repository.

2. Clone the repo:
```
git clone https://github.com/speratus/avant-guard-backend
```

3. navigate into the repo and run:
```
bundle install
```

4. Once all the dependencies have been installed run the following commands to get the 
    database setup:
```
1. rake db:create
2. rake db:migrate
3. rake db:seed
```

This will create the database and populate it with the initial seed data. The seed data is required for the app to
function. Because seeding requires making API calls, each request has been rate limited so as to avoid overloading
the source API. As a result, it will take around 20 minutes to seed the database, but it may take as long as 42 minutes.

5. Once Seeding is complete, the server can be started by running:
```
rails s
```
If you have the [frontend](https://github.com/speratus/avant-guard-frontend) installed, you will be able to sign up for an account 
and start playing the game right away!

## Testing

You can run the tests by running the following command:
```
rake
```
If that does not work for some reason, you should also be able to use this command:
```
bundle exec rspec
```

## Dependencies

* [Ruby on Rails](https://rubyonrails.org/)
* [BCrypt](https://github.com/codahale/bcrypt-ruby)
* [JWT](https://github.com/jwt/ruby-jwt)
* [RSpec](http://rspec.info/)
* [Damerau-Levenshtein](https://github.com/GlobalNamesArchitecture/damerau-levenshtein)
* [Rest-Client](https://github.com/rest-client/rest-client)
* [Dotenv-Rails](https://github.com/bkeepers/dotenv)
* [Rack-CORS](https://github.com/cyu/rack-cors)