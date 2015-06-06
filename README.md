This coding exercise is used to gauge the level of Ruby on Rails
experience for developer candidates.

Feel free to use Ruby Gems, Google, Stack Overflow, or any other resources
available in a day-to-day working environment.

## Setup

Fork this repository and checkout the code to your local development
environment.

Run the Rake DB create and Migrate tasks:

    bin/rake db:create db:migrate

Run RSpec to verify test suite is working:

    rspec

## Submission

When code complete; please submit a [Pull Request][pr] to have your
branch reviewed.

## Coding Exercise

__Task 1:__ Write a Rake task to import [311 case data][data] into a SQL database.
The rake task should run everyday at 12:00am and import all new cases since last run.

We use MySQL, so this project is setup accordingly, but if you're more comfortable with
Postgres, you can change the DB config.

Example usage of 311 case data API:
https://data.sfgov.org/Service-Requests-311-/Case-Data-from-San-Francisco-311/vw6y-z8j6

__Task 2:__ Implement JSON API endpoints to view and filter 311 case data for the
following scenarios.

    GET /cases.json
    # Returns all cases

    GET /cases.json?since=1398465719
    # Returns cases opened since UNIX timestamp 1398465719

    GET /cases.json?status=open
    # Returns cases that are in open state.

    GET /cases.json?category=General%20Requests
    # Returns cases that belong to "General Requests" category

    GET /cases.json?near=37.77,-122.48
    # Returns cases that were created within 5 mile radius of lat=37.77 and lng=-122.48

    GET /cases.json?near=37.77,-122.48&status=open&category=General%20Requests
    # API endpoint should be able to take any combination of GET params.

__Task 3:__ Include test/specs for Rake task and API.

[pr]: https://help.github.com/articles/using-pull-requests
[data]: http://data.sfgov.org/resource/vw6y-z8j6.json
