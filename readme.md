Rails Decal Project 1 (Due TBA)
==================================

For Project 1, we're going to be making a social media website! Our application is going to have the following features:

* The ability to sign up as a user
* The ability to post status updates
* The ability to view other users' profiles
* The ability to "like" users' posts

For a link to a completed version of what we're going to be creating, go here:

LINK TO APPLICATION

Part 0 -- Initial Application and Things to Remember
------------------------------------------------------

Throughout this project, any line of code that starts with a `$` such as:

    $

is meant to be run in your terminal (shell) and anything that begins with a `>` such as:

    >

is meant to be run in your Rails Console (by running the command `rails console`).

To run the Rails server, run:

    $ rails server

or just `rails s` for short.

At anytime, you can run the Rails console to inspect and modify your database. Simply run the command:

    $ rails console

or just `rails c` for short.

Fork this repository to your GitHub by clicking the `Fork` button in the top right corner. Then, go to your
Terminal and clone the repository using the command:

    $ git clone https://github.com/<your github username>/proj-1

Replace `<your github username>` with your actual GitHub username.

Throughout this project, you should be adding parts of the project to your git repo as you complete them.
We'll guide you how to do this throught the instructions, but the general workflow will be along the lines of:

    $ git add .
    $ git commit -am "Add User model"
    $ git push origin HEAD

Remember that when working with a new Rails project, you need to install all of the gems by running the command:

    $ bundle install

The initial application that we are giving you already contains some static pages, namely the home page.

Remember that if you have any questions, feel free to post them on Piazza or come to office hours!


Part 1 -- Creating the User Model
-------------------------------

In this part, we're going to create our user model. Our user model is going to have the following fields:

* Name
* Email

Now, in order to make our model, we're going to have to determine the types of those fields. Remember,
our choices include: `integer`, `text`, `string`, `datetime`, `boolean` and many more.

Recall that in order to make a model, we have to run the rails generator (fill in the \<type\> sections yourself):

    $ rails generate model User name:<type> email:<type>

This will create a file called `<timestamp>_create_users.rb` in our `db/migrate` folder with the specified
columns that we listed above.

After our migration is created, we must actually remember to run our migrations by running the following command:

    $ rake db:migrate

By now, you should know that command like the back of your hand.

Part 2 -- Let's be Secure
-------------------------------

But wait! How are our users going to log in? We need to make our user model secure. Let's add a `password` to our user.

Now, in order to make our `User` model secure, we're going to have to use a little more magic. We want to use
something called a *hash*. Don't confuse this *hash* with the hash object similar to a dictionary in Python. This
hash is a security term used to describe applying a [hash function](http://en.wikipedia.org/wiki/Hash_function) to data
so that it cannot be reverse engineered.

Luckily, we don't have to do this ourselves. In Rails 3.1, a special method, `has_secure_password` was introduced to help us with this problem. Before we can use this method, we're going to need to add a few more columns to the User model.

The `has_secure_password` method requires a column on our User model called `password_digest`. It should be a string.
Let's go ahead and write a migration to add this column to the User model. Hashing the password makes it so that
a hacker cannot sign in to a user's account if they managed to steal a copy of the database.

As always, don't forget to run `rake db:migrate` after adding your migration.

To encrypt our passwords, we're going to need to add a gem `bcrypt-ruby`. Let's add that to our `Gemfile` by adding
the line:

    gem 'bcrypt-ruby', '3.1.2'

Then, run the command:

    $ bundle install

Now you have bcrypt installed!

In order for our users to sign up, we're going to have them enter in both a `password` and a `password_confirmation`.
Luckily, the `has_secure_password` method creates both of these fields for us as *virtual* attributes -- that is, they don't
actually exist in the database, however, we're going to use them to generate our `password_digest` value.

To finally add the `has_secure_password` method to our User model, all we need to do is...add it to the User model!

Your User model should look like this:

    class User < ActiveRecord::Base
      .
      .
      .
      has_secure_password
    end

That's it! Now your User model is secure.

One last thing, we need a way to retrieve our users from the database in a secure way. We want to be able to
look up users by their `email` and `password`, confirm that they match a user, and then sign them in. The
`has_secure_password` helper adds this functionality as well through the method `authenticate`.

Later on, we're going to want to find our user and check to see if his/her inputted password matches. Here's
a sneak peek into how that is going to work.

First, we want to find a user with a specific email address. For this, we're going to use the `find_by` method.
The `find_by` method takes in any number of fields and the values that you want to find a specific entry for.
If such an object exists in the database, it'll return it. Otherwise, if this method is unable to find an object
that satisfies all of these conditions, it will return `nil`.

For our User model, we want to run something like:

    > user = User.find_by(email: "howard@swag.com")

Then, we can check to see if this User has the correct password by running the command:

    > current_user = user.authenticate("howardssupersecurepassword001")

If that is indeed Howard's password, this method will return the User object for Howard. Otherwise,
if that is the incorrect password, this method will return `false`.

Part 3 -- Signing Up and Signing In
-------------------------------

Now that we have our User model, we need a way for the user to sign in on the website.
But, before they can sign in, they need to sign up!

Signing up on an application is the same as creating a new user, so let's add a route that let's
us do that. Add the following line to your routes file:

    get "signup", to: "users#new"

Just a quick refresher, this creates a url `/signup` that points to the controller `users` and the method `new`.

Now that we have our route set up, we're going to need a `UsersController` with a method `new`. Recall that to create
a controller, we can just run the Rails generator:

    rails generate controller Users new

Open up `app/views/users/new.html.erb` and take a look at what's there:

    <h1>Users#new</h1>
    <p>Find me in app/views/users/new.html.erb</p>

Then view the page at: `localhost:3000/users/new`

Let's replace that with a sign up form!

    <% provide(:title, 'Sign up') %>
    <h1>Sign up</h1>

    <div class="row">
      <div class="span6 offset3">
        <%= form_for(@user) do |f| %>

          <%= f.label :name %>
          <%= f.text_field :name %>

          <%= f.label :email %>
          <%= f.text_field :email %>

          <%= f.label :password %>
          <%= f.password_field :password %>

          <%= f.label :password_confirmation, "Confirmation" %>
          <%= f.password_field :password_confirmation %>

          <%= f.submit "Create my account", class: "btn btn-large btn-primary" %>
        <% end %>
      </div>
    </div>

Let's try to reload the page...oh no! Looks like we need to define our `@user` variable. Add a line to
the `UsersController` to set the instance variable `@user` by creating a new instance of the `User` class.

After reloading the page again, we have another error, this time, there's an undefined method `users_path`.
What does this mean? It means we're missing a route that allows us to submit the form. We need to a add a POST
endpoint at `/signup` that calls the correct method on the `UsersController`. Which method do we want to add? Think
about which method is responsible for creating a new User object.  Also remember to add the method and views that come
after creating the user, and here's a hint, it starts with 's' and it finds a user by ID.

After adding that method to the `UsersController` (you can leave the method blank for now) as well as adding the
correct route to `routes.rb`, reload the page.

NOTE: Some useful debugging tips:

* Remember you can run `rake routes` in your terminal to see a list of all the routes you have defined in `rotues.rb`
* Remember the `as: ` syntax for adding a name to the routes

Fill in the method you just created with the correct implementation to create a new user object and save it to the database.
If you're seeing errors such as the `ActiveModel::ForbiddenAttributesError`, refer back to the [lab on creating objects](https://docs.google.com/document/d/1eRJ8uGfZNohrTnSZgrrFF7X3mvcHdztRhDrfKV1jf9E/edit)


Part 4 -- Post and Likes
-------------------------------
You know what would make our social media app exciting?  Have post and likes!  To create our post model we can simply run
a generator:

    rails generate model Post content:text user:belongs_to

We can break down this generator into parts.  First Post is the name of the model, and thus the generator will create a model
called Post and generate a migration that will create a table for Post.  Now the next part of the command is content:text.
What the generator will then do is create a column called content and make it of type text.  Now the more interesting part
is the next part, user:belongs_to.  What this will do is create a column called user that contains an integer, and that integer
will be the ID of the user the post belongs to.  Why didn't we just use user:integer then?  We did user:belongs_to because
it also adds the belongs_to :user to the Post model ruby file (you can see this line if you look at app/models/post.rb).  This
line tells the model that there is a relationship between the post and a user, specifically that a post belongs to a user.

Now lets generate a model for a like in a similar manner.  But let's think, what kind of relationship does a like need?  If
you guessed that a belongs to a user and a post, you are correct!  To generate this let's run the command:

    rails generate model Like user:belongs_to post:belongs_to

This will get rails to generate a like model that belongs to both a post and a user.

Now let's show the user's post.  Remember how we hinted at a certain view you should probably redirect to after you create
a new user?  Well I'm going to just spill the beans and tell you it's the show view.  In the show view let's just say
in addition to the user's information you also want to show the user's posts.  After putting information like the users
name and email in the view append this at the bottom.

    <div class="span8">
      <% if @user.posts.any? %>
        <h3>Posts (<%= @user.posts.count %>)</h3>
        <ol class="Posts">
          <%= render @posts %>
        </ol>
      <% end %>
    </div>

To break it down first we do some html stuff you don't need to really know about, which is creating a div with a class span8,
this is just styling.  Now the next line is embedded ruby code that checks to see if user's have any post.  Currently this
line actually doesn't work but just bear with us for now.  The next important line embedded ruby line is render @posts, which
is basically to show all the values in the @posts variable.  How does it know how to format it?  We'll define that later.

First let's give the ability for a User to see it's own post.  In your User.rb model, write the line

    has_many :posts, dependent: :destroy

This tells the user model that we have another model called post that looks up to it.  With that line, whenever we call a User's
.posts method, it will query our database for Posts that have a user_id that is the same as the User that is calling the method.
The .any? function just tells us whether or not we have any variables in that list (it will return either true or false).  The
dependent :destroy just tell's us that the post are dependent on the User it looks up to so when a User is destroyed so are
all the posts that look up to it.

Next we have to worry about rendering the @post.  How does the following line in our view work?
    <%= render @posts %>
It will look for a a default formatting of a post.  Let's define one in our posts views.  Create a folder in your views
for posts, and within it create a file called \_post.html.erb.  This naming convention just gives us some default rendering
for a post object.  Now within the file write the following erb code.

    <li>
      <span class="content"><%= post.content %></span>
      <span class="timestamp">
        Posted <%= time_ago_in_words(post.created_at) %> ago.
      </span>
    </li>

To break this down li is an HTML tag for a list item.  Within the span it accesses the content of a post and the field post.created_at.
What time_ago_in_words does is it just formats a DateTime to a more easily readible string.

Now all that's left for you to do to make this all work is to make sure you assign the values @user and @posts in your show function
of your Users controller and route the show view.  Initially your show view should not have any posts because you haven't made any,
but if you open up the rails console and manually create post with content and a user_id that matches the one you want to look at,
you can refresh your page and they should appear.
