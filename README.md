# PARKR

Welcome fellow environmentalists. You have reached the development website for PARKR, the premier application in the exciting field of Green Technology. 
Did you ever have an insatiable urge to explore the hundreds of national parks in the US? With PARKR, you can satiate that urge with a simple and slick CLI interface.

## Project Description

### Authors
1. Richard 상윤 Park
2. Xavier Ruiz

### Functionality
Once the user inputs their name and home state, they will reach a menu screen which presents them with 5 options:

1. Return parks within your homestate or a given state
2. Return information about a specific park
3. Update inputted user data
4. Modify your saved favorites list
5. Return all existing written reviews

The user can also return to the application whenever they want with our login feature, which saves their favorites and reviews.

## Instructions

1. Fork and clone this repository.
2. Delete the vendor folder if it exists
3. run bundle install 
4. To seed database, run rake db:migrate and rake db:seed
5. run run.rb in terminal "ruby ./bin/run.rb"
6. Enjoy

6.5 If you ever seed new data, please destroy_all Favorite using (rake console, favorite.destroy_all)

### Resources
Gems:
1. gem "sinatra-activerecord"
2. gem "sqlite3", '~>1.4.1'
3. gem "require_all"
4. gem "httparty"
5. gem 'tty-prompt'
6. gem 'rmagick', '~>2.16.0'
7. gem 'catpix'

API: National Park Service
https://www.nps.gov/subjects/developer/api-documentation.htm#/


## Contributor's Guide
Everything in this repo is avialiable, as long as credit is given to the authors.

## Licensing
  PARKR can be used by the conditions by the MIT License.
  **Resource:** [MIT License](https://opensource.org/licenses/MIT)