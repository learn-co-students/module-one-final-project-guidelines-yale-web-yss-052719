# Appster

Hi, I'm Owly 🦉:

Welcome to Appster, a Command Line Interface application that helps students research opportunities in higher education.

We have developed and shared the following MVP proof of concept in order to demonstrate the functionality for both students and colleges.

For students, we present college recommendations to students based on their academic background and allow students to store these recommendations by creating a list of applications.

For colleges, we allow administrators to learn more about what kind of students are interested in them and to better connect with these students through targeted marketing.

We believe in creating a world in which,
* great schools can reach out to more students,
* more students can find about more great options,
* and more students graduate with less debt!


## Project Description

This project uses Ruby and ActiveRecord, along with Sqlite3 for database management. Data is taken from the [US Department of Education API](https://collegescorecard.ed.gov/data/documentation/), and the seed data includes information from 2306 colleges and universities across the country.


### Functionality

Login

1. Users (students and colleges) can create unique usernames
2. Usernames are stored in a database, so Appster remembers your information when you log back in
3. Students can explore Appster's features even without having taken the SAT or ACT
4. Users can exit the login or create username process by simply typing in exit!

Students

Students can do the following:
1. Get a college recommendation - Appster recommends three schools ever time based off of their admissions criteria.
2. Look up a college - Students can find out more about their recommendaiton or any university in the US with this feature.
3. Create an application - Students can store recommendations or add their own schools to a list of applications, which will automatically be categorized as a target, reach, or safety based off of Appster's data analysis.
4. Look up applications - Students can access their applications and make changes.
5. See and update information - Students can make changes to the information they have stored in their profile if, for example, they change schools or get a new test score

Colleges

Colleges can do the following:
1. Look up students - Colleges can see information about every student interested in them or certain students based off of their characteristics
2. See information - Colleges can see which administrator username is currently associated with their school.


### Authors
1. [Peter Hwang](https://github.com/cirediatpl)
2. [Max Sun](https://github.com/maxsunnyday)

If you have any suggestions for us, please reach out to us on Github!


### Gems
* sinatra-activerecord
* rake
* sqlite3
* httparty
* json
* database_cleaner
* rspec
* tty-prompt
* catpix
* colorize


## Setup Instructions

1. Fork and clone this repository.

2. Install required gems:

    bundle install

3. OPTIONAL: You may get an error when installing the rmagick gem in Mac OSX. To troubleshoot follow these [instructions](https://blog.francium.tech/installing-rmagick-on-osx-high-sierra-7ea71f57390d) or enter the commands below into terminal:

    brew uninstall imagemagick
    brew install imagemagick@6
    export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"
    brew link --force imagemagick@6
    gem install rmagick

5. To seed database:

    rake db:migrate
    rake db:seed

6. To run:
    ruby bin/run.rb


## Thank you

Special thanks to Prince Wilson and Gigi Hoagland, the instructors for the Flatiron School Web Development Course, and to our classmates including Matt, Rina, Ekow, Richard, Xavier, and the many others who took a look at our code, gave us suggestions, and were our test users or "guinea pigs" 🐹 as Owly 🦉 likes to call them!

Also thank you to past Flatiron alumni, such as Anthony C, Peter H, Daniel C, Zohra A, and Joy H, whose projects and documentation inspired us as we built our first project (not to mention, helped us save hours of debugging time).


## Licensing
  Appster can be used by the conditions by the MIT License.
  **Resource:** [MIT License](https://opensource.org/licenses/MIT)
