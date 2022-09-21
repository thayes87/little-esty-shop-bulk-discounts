# Little Esty Shop

Practice designing a normalized database schema and defining model relationships as well as utilized advanced routing techniques including namespacing to organize and group like functionality together. Utilize advanced active record techniques to perform complex database queries and practice consuming an public API while utilizing POROs as a way to apply OOP principles to organize code.

## Ruby/Rails version

**ruby '2.7.4'**
**rails '5.2.8'**

## System dependecies

**ruby '2.7.4'**
**rails '5.2.8'**

#### Testing:
* pry
* rspec-rails
* simplecov
* capybara
* launchy
* shoulda-matchers
* orderly
* webmock
* figaro

#### Production:
* HTTParty

## Configuration

To setup the project you will first install the system dependecies by running;
```
bundle install
```

## Database creation and initialization

To setup the database first run this command;
```
rails db:{drop,create,migrate}
rails csv_load:all (If you want all data)
rails csv_load_mock:all (if you want mock data)
```

## How to run test suite

If you installed the testing dependecies you will be able to run;
```
rails test_db:setup
bundle exec rspec -fd
```

This will run all of the tests located in the spec folder.

## Project technology

This project is running the following languages and tools:

* Ruby
* RSpec
* Ruby on Rails
* SimpleCov
* Git-Hub API

## Links

- Project homepage: https://github.com/Dominicod/little-esty-shop
- Repository: https://github.com/Dominicod/little-esty-shop
