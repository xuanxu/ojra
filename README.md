# OJRA: Open Journals Reviewers API

A Ruby wrapper for the Open Journal's Reviewers application's API

[![Tests](https://github.com/xuanxu/ojra/actions/workflows/tests.yml/badge.svg)](https://github.com/xuanxu/ojra/actions/workflows/tests.yml)
[![Gem Version](https://badge.fury.io/rb/ojra.svg)](https://badge.fury.io/rb/ojra)

## Use

### Installation

Install OJRA running:

```
gem install ojra
```

Or adding the gem to your project's `Gemfile`:
```ruby
gem "ojra"
```

### Authentication

Initialize the API Client class with the URL of the Reviewers site and a valid API token:

```ruby
  require "ojra"

  client = OJRA::Client("https://reviewers-app.url", "secretTOKEN1234")
```

### Available methods

**STATS:**


 - **assign_reviewers(reviewers_list, issue_id)**: Add a new active review to a reviewer or list of reviewers (array or comma separated string)
 ```ruby
    client.assign_reviewers("@reviewer21", 4321)
    client.assign_reviewers("@reviewer21, @reviewer33, @reviewer42", 4321)
    client.assign_reviewers(["reviewer21", "reviewer33", "reviewer42"], 4321)
 ```

 - **unassign_reviewers(reviewers_list, issue_id)**: Log a review unassignment for a reviewer or list of reviewers (array or comma separated string)
 ```ruby
    client.unassign_reviewers("@reviewer21, @reviewer33, @reviewer42", 4321)
    client.unassign_reviewers("@reviewer21", 4321)
    client.unassign_reviewers(["reviewer21", "reviewer33", "reviewer42"], 4321)
 ```

  - **start_review(reviewers_list, issue_id)**: Log starting a review for a reviewer or list of reviewers (array or comma separated string)
 ```ruby
    client.start_review("@reviewer21", 4321)
    client.start_review("@reviewer21, @reviewer33, @reviewer42", 4321)
    client.start_review(["reviewer21", "reviewer33", "reviewer42"], 4321)
 ```

 - **finish_review(reviewers_list, issue_id)**: Log end of review for a reviewer or list of reviewers (array or comma separated string)
 ```ruby
    client.finish_review("@reviewer21", 4321)
    client.finish_review("@reviewer21, @reviewer33, @reviewer42", 4321)
    client.finish_review(["reviewer21", "reviewer33", "reviewer42"], 4321)
 ```

