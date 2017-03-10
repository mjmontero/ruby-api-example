# Sample Ruby API

## Sample Objectives

You will be creating a simple user management API using the tools described below. Already provided is a very basic ruby application which you will need to build the following endpoints for:

### Features that you need to implement
1. POST /users - Create a new user. It should accept the following fields: first name, last name, email, password, date of birth.  Date of Birth is the only optional field. Upon successful creation it should send an email to their address confirming the new account (add the mail gem or any other mailer you prefer)
2. PUT /users/:id - Update a user. Add authentication so only the current user can update their own account. There is already a user ability created for this (see `application/lib/abilities.rb`).
3. PATCH /users/:id/reset_password - Update a user password. It should accept the following fields: new_password, confirm_password. It should also send them an email letting them know their password has been updated.

### Coding guidelines for each feature
1. All endpoints should have their input and response formats defined using Grape Entities (see URL for library below).
2. Input data should be validated using Hanami forms.
3. Each feature must have a spec testing different scenarios and possible failures.  Check that the data is being returned properly.
4. Use grape-swagger to automatically generate swagger docs.
5. Use background processing where applicable, like mailers (ie. Sidekiq gem).  Make sure to have independent spec tests for these jobs.
6. Come up with your own authentication pattern in `application/api_helpers/auth.rb`  (examples include: ruby-jwt, generic oauth, signature headers)


## Installation Process:

1. Install RVM (https://rvm.io/rvm/install)
2. Run `rvm install 2.3.3`
3. Run `gem install bundler`
4. Clone repository
5. `cd ruby-api-example`
6. Run `bundle install`
7. Duplicate .env.development.sample file and rename to .env.development
8. Enter correct env values for .env.development
9. Repeat steps 7 and 8 for env.test
10. To start ruby server, run `make run`
11. The API will now be accessible at http://localhost:3000/api/v1.0/users

**Note:** Be sure to set database url for env.test to your test database and not your development database. Tests will truncate all tables in the test database before running!

## Libraries

### Routing

Grape: https://github.com/ruby-grape/grape

Grape Entity: https://github.com/ruby-grape/grape-entity

Grape Swagger: https://github.com/ruby-grape/grape-swagger

### Database / Models

Sequel: http://sequel.jeremyevans.net/

### Forms

Hanami: https://github.com/hanami/validations

Uses dry validation as the syntax to validate inputs. Suggested reading: http://dry-rb.org/gems/dry-validation/

### Testing

Rspec: http://www.relishapp.com/rspec/rspec-core/docs

Factory Girl: https://github.com/thoughtbot/factory_girl

Faker: https://github.com/stympy/faker

## Migrations

To create a migration: `bundle exec rake "db:migration[my_migration]"`

To code the migration: go to `application/migrate/XXXXXX_my_migration.rb` -- instructions here: https://github.com/jeremyevans/sequel/blob/master/doc/migration.rdoc

To apply the migration: `bundle exec rake db:migrate`

To apply the migration to your test database: `RACK_ENV=test bundle exec rake db:migrate`

## Running Tests

Run your tests using:

`make test`

Run a specific test by providing the path to the file:

`bundle exec rspec ./application/spec/users_spec.rb`

## Contributing

Our goal in development is to keep the main repository clean. To achieve this, we fork the repository to our own accounts. This lets us maintain our own branches without cluttering the main repository. When branches are ready to be merged into the main repository, we create a pull request. Usually the pull request goes to staging so the updates can be tested before pushed to the production server. However, if it is a hotfix for a critical bug, creating a pull request to master is also allowed.

### Forking Procedures

1. Fork the repo to your own github account
2. Clone the forked repo locally
3. Add the main repository as your 'upstream' remote:
    - `git remote add upstream git@github.com:acdcorp/REPOSITORY_NAME.git`
4. When you need to sync with the master repository, fetch the upstream:
    - `git fetch upstream`
    (you can use this to then git merge upstream/master or whichever upstream branch you may need)
5. Create a new branch for the feature you are assigned. Make NEW_BRANCH_NAME descriptive of what you're working on:
    - `git checkout -b NEW_BRANCH_NAME`
6. When you have code ready for pull request or to be reviewed/contributed by peers:
    - `git push origin BRANCH_NAME`
    - Then go to the main repository and create a pull request to the `staging` branch
7. Link up other developers working fork of the repository:
    - `git remote add DEVELOPER_USERNAME git@github.com:DEVELOPER_USERNAME/REPOSITORY_NAME.git`
    - `git fetch DEVELOPER_USERNAME`
8. Optionally merge or checkout another developer's branch
    - `git checkout DEVELOPER_USERNAME/BRANCH_NAME`
    - `git merge DEVELOPER_USERNAME/BRANCH_NAME`



