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

Just a quick refresher, this creates a url `/signup` that points to the controller `users` and the method `new`

