# Flight tracker
A small flight tracker app that allows you to create, edit, and delete flights. It validates input before entry.

# Start 
1. `$ bundle install`
2. `$ bundle exec ruby tracker.rb`

# Technologies Used
- Ruby
- Sinatra
- PostgreSQL
- HTML

# Notes
Input validation within Add Flight:
- Flight number must be 4 digits
- Date must be yyyy-mm-dd and not in past
- Time must be hh:mm
- Timezone must be one of [HST, AKDT, AKST, PDT, PST, MDT, MST, CDT, CST, EDT, EST, AST]
- All fields must be filled in
