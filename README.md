# OJRA: Open Journals Reviewers API

A Ruby wrapper for the Open Journal's Reviewers application's API

## Use

### Installation

Install OJRA running

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


 - **assign_reviewer(reviewer, issue_id)**: Add a new active review to a reviewers' stats
 ```ruby
    client.assign_reviewer("reviewer21", 4321)
 ```

 - **assign_reviewers(reviewers_list, issue_id)**: Add a new active review to a list of reviewers (array or comma separated string)
 ```ruby
    client.assign_reviewers("@reviewer21, @reviewer33, @reviewer42", 4321)
    client.assign_reviewers(["reviewer21", "reviewer33", "reviewer42"], 4321)
 ```


 - **unassign_reviewer(reviewer, issue_id)**: Log end of review for a reviewer
 ```ruby
    client.unassign_reviewer("@reviewer21", 4321)
 ```


 - **unassign_reviewers(reviewers_list, issue_id)**: Log end of review for a list of reviewers (array or comma separated string)
 ```ruby
    client.unassign_reviewers("@reviewer21, @reviewer33, @reviewer42", 4321)
    client.unassign_reviewers(["reviewer21", "reviewer33", "reviewer42"], 4321)
 ```

