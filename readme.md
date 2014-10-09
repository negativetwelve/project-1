### Rails Decal Project 1 (Due TBA)

For Project 1, we're going to be making a social media website! Our application is going to have the following features:

* The ability to sign up as a user
* The ability to post status updates
* The ability to view other users' profiles
* The ability to "like" users' posts

For a link to a completed version of what we're going to be creating, go here:

LINK TO APPLICATION

#### Part 1 -- Creating the User Model

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

#### Part 2 -- Let's be Secure

But wait! How are our users going to log in? We need to make our user model secure. Let's add a `password` to our user.

Make a migration to add the column `password` to the `User` model.

Now, in order to make our `User` model secure, we're going to have to use a little more magic. We want to use
something called a *hash*. Don't confuse this *hash* with the hash object similar to a dictionary in Python. This
hash is a security term used to describe applying a [hash function](http://en.wikipedia.org/wiki/Hash_function) to data
so that it cannot be reverse engineered.
