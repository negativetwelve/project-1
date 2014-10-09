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

