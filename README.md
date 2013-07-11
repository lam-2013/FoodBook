## SWorD ##
SWorD (Social Web of real Domotics) is a prototype social network where users, homes, providers, devices and appliances can interact and act in a "smarter" way, by talking each other and thus lowering the technical knowledge to use home automation and domotics systems.

### LAB2 ###
1) Creation of static pages for our social network: home, about and contact

- `rails generate controller Pages home about contact` (or from the RubyMine menu *Tools > Run Rails Generator...*)

2) Add title to HTML files: "SWorD | Page name"

- by using the `provide` method in each view, i.e., `<% provide :title, 'Page name' %>`
- by editing the title tag in `app/views/layouts/application.html.erb`, i.e., `<title>SWorD | <%= yield(:title) %>`
- learn more about `provide` at [http://api.rubyonrails.org/classes/ActionView/Helpers/CaptureHelper.html#method-i-provide](http://api.rubyonrails.org/classes/ActionView/Helpers/CaptureHelper.html#method-i-provide)

3) Add an helper to avoid wrong rendering if the page title is not declared

- in `app/helpers/application_helper.rb`
- by editing the title tag in `app/views/layouts/application.html.erb`

### LAB4 - Preparation ###
1) Fill with some contents all the views

2) Add `bootstrap-sass` gem to include the Bootstrap framework with Sass support [http://twitter.github.io/bootstrap/](http://twitter.github.io/bootstrap/)

- update the `Gemfile`
- run `bundle install`

3) Add and fill a custom SCSS file in `app/assets/stylesheets`

### LAB4 ###
1) Move HTML shim, header and footer code in three partials (placed in `app/views/layouts/`)

2) Update the `routes.rb` file, according to the table present in the exercise 1 text

3) Update links present in `_header.html.erb` and `_footer.html.erb`

4) Add a faq page:

- add a new view called `faq.html.erb` with a content similar to the other views
- update the Pages controller
- add the corresponding named route to `routes.rb`

5) Add a Users controller and a page named "new"

- `rails generate controller Users new` (or from the RubyMine menu *Tools > Run Rails Generator...*)
- fill the content of the `new.html.erb` view
- update/add the corresponding named route to `routes.rb`, mapping it with the signup URI
- update the "Sign Up" link present in `home.html.erb`

### LAB 5 ###
1) Generate the User model, with two attributes: name and email

- `rails generate model User name:string email:string` (or from the RubyMine menu *Tools > Run Rails Generator...*)

2) Migrate the model to the database (i.e., create the table and columns corresponding to the User model)

- `bundle exec rake db:migrate` (or from the RubyMine menu *Tools > Run Rake Tasks...*)

3) Add some gems to the Gemfile (and perform a `bundle install`)

- `annotate` (version 2.5.0) to show some annotations in the Rails models
- `bcrypt-ruby` (already present, but commented) to have some state-of-the-art hash functions available in Rails

4) Annotate the User model to show a little bit more information

- `bundle exec annotate` (or add a new configuration of type *Gem Command* from the RubyMine menu *Run > Edit Configurations...*)

5) Add debug information in `application.html.erb`, by using the `debug` method

6) Add some validations to the User model

- `name` must be always present (`presence: true`) and it must have a maximum length of 50 characters (`length: { maximum: 50 }`)
- `email` must be always present, unique (`uniqueness: { case_sensitive: false }`) and with a specific defined format (`format: { with: VALID_EMAIL_REGEX }`)

7) Enforce the uniqueness of the email by using a migration

- add an index on the `email` column in the database

8) Give to the User model a `password` field

- generate/migrate a migration to add a column to store the password digest (i.e., an encrypted version of the password)
- update the User model with two virtual attributes: `password` and `password_confirmation`
- add the `has_secure_password` method to the User model, to use the authentication system of Rails

### LAB 6 - Preparation ###

1) Add routes for users

- `resources :users` in `config/routes.rb`

2) Add a user in the database, by editing the action `new` in the Users controller

3) Add a new view associated to the Users controller

- create `show.html.erb` in `app/views/users` (filled with some contents)
- update the page stylesheet
- add the corresponding action to the User controller (`users_controller.rb`)

4) Add an helper for using a Gravatar as profile pic for the users (in `users_helper.rb`)

- update the view responsible of showing users (`show.html.erb`)

### LAB 6 ###

1) Complete the Gravatar helper

2) Remove the existing user

- in the database: `bundle exec rake db:reset` (or from the RubyMine menu *Tools > Run Rake Tasks...*)
- in the code: delete the lines in the `new` action of the Users controller

3) Add the sign up form in the `new.html.erb` view

- by using the `form_for` helper method, which takes in an Active Record object and constructs a form using the object’s attributes
- by adding `@user = User.new` to the corresponding action in the Users controller

4) Update the stylesheet for a better rendering of the form

5) Add the `create` action needed to the sign up form to the Users controller

- create a new User with the information inserted in the form
- if it is possible to save such a user into the database, go to the user profile page
- otherwise, go back to the sign up form

6) Update the sign up form to show error messages (if any)

- add a _error_messages.html.erb partial (in views/shared) to store the code for showing error messages of a generic form
- update the stylesheet

7) Add the flash to welcome newly registered users to our site

- insert an area to show the flash message in application.html.erb
- fill the flash if the user signup has been successful (i.e., in the Users controller)

### LAB 7 - Preparation ###

1) Include the SessionHelper to the ApplicationController (helpers are automatically added to views, but not to controllers) and create the corresponding helper

- add `include SessionsHelper` in `app/controllers/application_controller.rb`
- define a method named `handle_unverified_request` to prevent cross-site request forgery attacks in `application_controller.rb`
- create `sessions_helper.rb` in `app/helpers`

2) Add a migration to associate a user to its remember token (to be added in the traditional Rails session)

- generate/migrate a migration to add a column and a index for the remember token

3) Update the User model to handle the remember token

- add a callback method to create the remember token (`before_save :create_remember_token`); Rails will look for a `create_remember_token` method and run it before saving the user
- define such method as private and generate the token by using the `SecureRandom.urlsafe_base64` function to generate a random string, safe for use in URIs, of length 16

4) Define the `sign_in` method in the `SessionsHelper`

5) Define two methods to set and get the current (logged) user for passing this information to all the other pages in the `SessionsHelper`

6) Define a `is_signed_in?` method in the `SessionsHelper`

7) Define a sign out method in the `SessionsHelper`

### LAB 7 - Exercise 1###

1) Generate a Sessions controller

2) Update routes to implement the session as a RESTful resource

- add `match '/signin', to: 'sessions#new'` and `match '/signout, to: 'sessions#destroy', via: :delete`
- add `resources :sessions, only: [:new, :create, :destroy]`

3) Fill the Sessions controller with the required actions (new, create and destroy)

4) Create the view for the signin form (i.e., `app/views/sessions/new.html.erb`)

- we need to ask for email (the username in our social network) and password
- since a session is not a Model, define the form as `form_for(:session, url:session_path)`, where the former element is the resource name and the latter is the corresponding URL
- submit the form will result in `params[:session][:email]` and `params[:session][:password]` to be used in the `create` action

5) Write the `create` action in the Sessions controller

- get the registered user starting from the email given in the sign in form (`params[:session][:email]`)
- check if the user exist and if the given password is correct (`if user && user.authenticate(params[:session][:password])`)
- handle a successful login (call the `sign_in` method declared in the `SessionsHelper`)
- handle a failed login (show an error message and go back to the login form)

6) Update the links in the header

7) Add the Boostrap javascript library to `application.js`

8) Update the sign up method to perform a login if the registration was successful

9) Write the `destroy` action in the Sessions controller for signing out

- call the `sign out` method of SessionsHelper
- redirect to the homepage

### LAB 7 - Exercise 2 ###

1) Create the `edit` action and view for the Users

- please note that the `edit` view is almost identical to the `new` view

2) Update the Settings link in the header

3) Define the `update` action in the Users controller

- it is the action called after the edit form submission
- get the updated user information from the edit form (`params[:user]`)
- check if the update was successful and handle the success and fail cases

4) Since, right now, everyone can edit user information, implement some controls

- add a filter to the Users controller: before performing the edit and update actions present in the controller, check if the user is signed in (`before_filter :signed_in_user, only: [:edit, :update]`
- add a filter to the Users controller: before performing the edit and update actions present in the controller, check if the current user is the correct user (`before_filter :correct_user, only: [:edit, :update]`)
- add the two methods declared in the before filters in the Users controller
- add another helper method to the SessionsHelper: check if the user for which the editing actions are called is also the current user

5) Add the `index` action and view

- the action must be called only for signed in users: add `index` to the first `before_filter` in the Users controller
- in the view, cycle upon all the users
- update the `gravatar_for` helper to show different image sizes
- add some custom SCSS to `custom.css.scss`
- update the corresponding link in the header

6) Generate some sample users

- add the `faker` gem to the project
- perform a `bundle install`
- write a rake task (in `lib/tasks/sample_data.rake`) for generating 100 users
- clean the database content (`bundle exec rake db:reset`, or from the RubyMine menu *Tools > Run Rake Tasks...*)
- execute the newly created task (`bundle exec rake db:populate`, or from the RubyMine menu *Tools > Run Rake Tasks...*)

7) Add pagination to the `index` view and action

- add the `will_paginate` and the `bootstrap-will_paginate` gems
- perform a `bundle install`
- edit the `index` view to include the `will_paginate` method (it shows the link to the next and previous pages)
- edit the `index` action to properly prepare data for the correspective view (by using the `paginate` method in retrieving users)

8) Add the admin user

- generate a new migration to add the admin column in the database (with a boolean value): `add_admin_to_users`
- update the newly generated migration to set the admin field to false, by default
- migrate!
- update the `sample_data.rake` task to assign admin privilegies to the first user
- clean the database content (`bundle exec rake db:reset`, or from the RubyMine menu *Tools > Run Rake Tasks...*)
- execute the updated task (`bundle exec rake db:populate`, or from the RubyMine menu *Tools > Run Rake Tasks...*)

9) Let the admin delete other users

- edit the `index` view to add a delete link near each user
- add the `destroy` action in the Users controller
- update the `signed_in_user` filter to include the `destroy` action
- add a before filter named `admin_user` to ensure that only admin can delete users

### LAB 8 ###

1) Create the Post model, with two attributes: content and user_id

- `rails generate model Post content:string user_id:integer` (or from the RubyMine menu *Tools > Run Rails Generator...*)
- in the migration, add an index to help retrieve all the posts associated to a given user in reverse order of creation
- migrate such updates to the database

2) Update the Post model

- by removing `user_id` from the accessible attributes
- by validating the presence of `user_id`
- by validating the presence and the length of `content`

3) Link posts with users

- add `belongs_to :user` to the Post model
- add `has_many :posts` to the User model
- set a descending order (newest to oldest) from post, add `default_scope order: 'posts.created_at DESC` to the Post model
- if a user is destroyed, all her posts must be also destroyed: update the relationship between users and posts in the User model

4) Show the posts in the user home page

- update `show.html.erb` between the Users view
- add a partial (`app/view/posts/_posts.html.erb`) for showing a single post
- edit the `show` action in the Users controller to correctly handle the updated view

5) Create some fake posts by editing the `sample_data.rake` task

6) Add some custom SCSS

7) Add the `create` and `destroy` route for the Posts resource in `routes.rb`

 - we show posts through the Users controller, so we don't need any other route

8) Create an (empty) Posts controller

9) Only signed in users can create or delete a post

- move the `signed_in_user` method to the `SessionHelper`
- add a `before_filter` to the Posts controller

10) Add code for creating a new post

- add a `create` action in the Posts controller to build and save a post
- update the homepage to show different content whether a user is logged in
- add a form for the creation of a new post in the homepage (`home.html.erb`) and update the corresponding action in the Pages controller
- update the `error_messages` partial to handle errors coming from various objects, not only User

11) Add code for deleting an existing post (each user can delete only her own posts)

- add a `destroy` action in the Posts controller to delete a post
- add a link for deleting a post in the `post` partial (in `app/views/posts`), similar to the one used for deleting a user
- add a `before_filter` in the Posts controller to check if the user is allowed to delete the desired post (`correct_user`)
- define the `correct_user` private method in the Post controller

### LAB 9 ###

1) Generate a Relationship model for followers and followed users

- `rails generate model Relationship follower_id:integer followed_id:integer` (or from the RubyMine menu *Tools > Run Rails Generator...*)
- add three indexes on `follower_id` and `followed_id` (by acting on the migration)
- remove `follower_id` from the list of accessible attributes of the model
- migrate the whole

2) Build the User/Relationship association

- a user has many relationships: update the User model
- a relationship belongs to a follower and a followed user: update the Relationship model

3) Add some validations on the two attributes of the Relationship model

4) Update the User model to include Followed user properties

- a user has many followed user, through the relationships table
- define some useful methods (is the current user following a given user? follow and unfollow a user)

5) Update the User model to include Followers properties

- a user has many "reverse" relationships
- a user has many followers through the previously defined "reverse" relationships table

6) Add some sample following data by updating the `populate` rake task

- reset the database, and populate it again

7) Add routes for following and follower

8) Add some user statistics (e.g., number of followers and followed users)

- create the `_stats.html.erb` partial in the `shared` folder
- include the partial in the home page and in the user profile
- update the stylesheet

9) Add the follow/unfollow button (form)

- create the a general `_follow_form.html.erb` partial in the `view/users` folder
- add a route for handling relationships
- create the `_follow.html.erb` partial in the `view/users` folder
- create the `_unfollow.html.erb` partial in the `view/users` folder
- render the `_follow_form.html.erb` partial in the user profile

10) Add pages for listing followers and followed users

- add two new actions in the User controller for following and follower (based on previous routes)
- add `show_follow.html.erb` in the `view/users` folder
- add a `_user.html.erb` partial in the `view/users` folder to avoid code replication

11) Add the `create` and `destroy` action in the Relationship controller

- create the Relationship controller

12) Add some ajax to the follow/unfollow button

- edit the `_follow.html.erb` and `_unfollow.html.erb` partials to support javascript
- update the Relationship controller to reload the destination page by using ajax
- create the javascript files corresponding to the two actions in `view/relationships`

13) Implement the status feed (i.e., the wall)

- we want to show, in the home page for a signed in user, her posts and posts from their followed users
- update the User model by defining a `feed` method to get these posts
- update the Post model to implement the method called by the User model for the wall
- add the status feed in the home page view/action
- update the `create` action in the Post controller to prepare a data structure for properly show the feed items

* * *

### Search users ###

1) Add a route to support simple user search, by editing `routes.rb` (to match `users/search`)

2) Create a partial in the users views for the search form

- render the search form in the header, only for signed in users

3) Implement the `search` action in the Users controller

- add the corresponding search method in the User model (`self.search` since it is a class method)
- add a `search` view for showing found users (in `/view/users/`)

### Private messaging between users ###

1) Add and install the [simple-private-messages](https://github.com/jongilbraith/simple-private-messages) gem to the Gemfile

2) Create the private message model by running the `simple_private_messages:model generator`

- `rails generate simple_private_messages:model User Message` (or from the RubyMine menu *Tools > Run Rails Generator...*)
- the previous operation generate a Message model and link it to the user model already present in the app (User, in our case)

3) Migrate the generated migration to create a `messages` table

4) Update the User model to use the newly created messages, by adding `has_private_messages`

5) Update the routes

- add a resource to create and destroy user's messages
- update the user resource to handle messages

6) Add `create` and `destroy` actions to the Message controller

7) Update the User show view to include a "New message" button (currently it is a link, but it could also be a form like the follow one)

- when clicked, call the `new` action in the Messages controller
- it will show a modal window to compose a new message

8) Update the User statistics (`stats` partial) to show received messages

- each user can see their own messages, only

9) Add to the User controller a `messages` action to show all the user's message

- create the corresponding view

10) Update the `new` action in the Message controller to compose reply messages

11) Update the `populate` rake task to generate some fake messages

