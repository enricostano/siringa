# Siringa :syringe:
This gem was born working on pure client acceptance testing in [Teambox](http://www.teambox.com).
## WARNING :warning:
Due to a conflict with reserved word `load` we are deprecating `#load` action in `SiringaController` in favour of `#load_definition`. This change is reflected by a warning in logs but will be dropped in version `0.1.0`.
## The problem

You have a Rails based API and you need to write some acceptance tests using your Javascript/iOS/Android/whatever client.

Probably you'll have three basic needs:

1. Pre-populate the DB with some (maybe massive) data (a.k.a. seed data)
2. Your seed data files have to be easily maintainable, you don't want to touch them too much when a model change and so on
3. Populate your DB while executing some specific acceptance test and then clean up the DB restoring the initial situation

## The solution

1. Write your seed data and use Siringa's rake recipes to pre-populate the DB just after you deploy your API
2. I suggest to use factories to create your seed data in order to take advantage of factories maybe you've already written for unit tests. But you could use whatever other way to keep your seed data maintainable and you still could use Siringa
3. Use Siringa's extra API endpoints in order to dump your inital DB situation, load some factories and then restore the initial status when you're done

**Why you don't just use your app's API to do the same thing, maybe storing JSON/XML objects in some fixture?**

Well, because mantaining those huge JSON/XML fixture files will be a nightmare.

## Install Siringa

Add the following to your `Gemfile`:
```ruby
group :test do
  gem 'siringa'
end
```
For security reasons, I suggest to add it under the `test` group. In that way you'll have Siringa available only running the app in `test` environment.

Run the bundle command to install it.

Run the generator:
```console
rails generate siringa:install
```
This will create an empty directory in `tmp/dumps`.

Add the following to your `config/routes.rb`:
```ruby
mount Siringa::Engine, :at => '/siringa'
```
Make sure that you add it in the correct environment. For instance if you want it available only in `test` environment put it inside a condition statement like `if Rails.env.test? .. end`.
## Create definitions

In order to create a new Siringa definition just create a new file in the `test/siringa` directory like the following:

```ruby
# test/siringa/definitions.rb
require 'siringa'
require File.expand_path('../../factories', __FILE__)

Siringa.add_definition :initial do
  FactoryGirl.create :user,
    name: 'Jesse Pinkman'
end

Siringa.add_definition :specific do
  FactoryGirl.create :user,
    name: 'Hank Schrader'
  FactoryGirl.create :project,
    name: 'Pollos Hermanos'
end
```

I'm using [FactoryGirl](https://github.com/thoughtbot/factory_girl) gem here but in a definition you could write whatever kind of Ruby code and Siringa will execute it when you call the definition.

## Load definitions
Now that we've created our definitions we could use them in our two cases:
### As seed data
You could just load the `initial` definition running the following rake recipe after your deploy:
```console
rake siringa:load_definition
```
`initial` is the default definition this Rake task recipe will try to load, if you want to load another definition instead you could pass its name as argument:
```console
rake 'siringa:load_definition[another_definition]'
```
This will load a definition named `:another_definition`. Please note that if you use Zsh shell you'll need to use quotes, more info [here](http://robots.thoughtbot.com/post/18129303042/how-to-use-arguments-in-a-rake-task).

If you want to force a Rails environment you could just run the Sriringa recipe specifing the `RAILS_ENV` environmental variable:
```console
RAILS_ENV=development rake siringa:load_definition
```

### During an acceptance test
As you can see running `rake routes`, Siringa added 3 new routes to your API:
```console
Routes for Siringa::Engine:
        POST /load_definition/:definition(.:format) siringa/siringa#load_definition
   dump POST /dump(.:format)             siringa/siringa#dump
restore POST /restore(.:format)          siringa/siringa#restore
```

The workflow I propose here is:

1. Create a dump of your DB performing a `POST` request to `YOURHOST/siringa/dump`

   This will create a `.dump` file in the `tmp/dumps` directory created during the install process. You could create as many dump files as you want but Siringa will keep only the latest 5 dumps created.

2. Load a Siringa definition performing a `POST` request to `YOURHOST/siringa/load_definition/specific`

   This will run the code defined in a definition named `specific` on the server.

3. Go ahead with your acceptance test

4. Restore the DB status performing a `POST` request to `YOURHOST/siringa/restore`

   This will bring back your DB at the initial status using the dump file you created in step 1.

   Please note that the `Siringa::restore` method only use the latest dump file created, older dump files in the `tmp/dumps` folder will be ignored.

## Customize Siringa
You could customize Siringa changing the configuration in the environment where you load Siringa:
```ruby
# config/environments/test.rb
Siringa.configure do |config|
  # customize the path where the definitions are stored
  config.definitions_path = 'test/siringa'
  # customize the path where the DB dumps are stored
  config.dumps_path = 'tmp/dumps'
end
```
## Acceptance test example
Just to get the idea, the following script will show you how to use Siringa in a acceptance test using Selenium, [rest-client](https://github.com/rest-client/rest-client) and RSpec:
```ruby
require 'selenium-webdriver'
require 'rspec'
require 'rest_client'

describe "Acceptance test using Siringa" do
  before(:all) do
    # Dump your DB
    RestClient.post 'YOURHOST/siringa/dump'
  end

  before(:each) do
    @driver = Selenium::WebDriver.for :firefox
  end

  after(:each) do
    @driver.quit
  end

  it "Loads a definition and test something" do
    # Loads a definition named 'specific'
    RestClient.post 'YOURHOST/siringa/load_definition', { definition: :specific }

    # Here goes your test

    # Restore your DB
    RestClient.post 'YOURHOST/siringa/restore'
  end
end
```
## To Do
* Write more tests
* Add Postgres adaptor compatibility for dumps and restores
* Add more customizations

## How to collaborate
* Fork the repo and send a pull request, thanks!

# License
MIT-LICENSE 2013 Enrico Stano
