class UsersController < ApplicationController

    # sign-up form. Redirects new user...
    get '/new' do
        erb :'/users/new'
    end

    # save a new user and redirect to login
    post '/' do
        user = User.new(username: params[:username])
        user.password = params[:password]
        # Users get a property called photo_path. (Check out user.rb.) Each photo is saved in public_folder/images, with a random 4-digit number appended to the photo name (my_pic2095.img) (Want to figure out how to put photos in the database.)  File.open needs two arguments. I think the b was for binary. 
        user.photo_path = user.format_photo_path(params[:photo][:filename])
        File.open("#{Dir.pwd}/public_folder/#{user.photo_path}", "wb") do |f|
            f.write(params[:photo][:tempfile].read)
        end
        user.birthplace = params[:birthplace]
        user.first_lang = params[:first_lang]
        user.dream_job = params[:dream_job]
        user.if_I_were_fancy = params[:if_I_were_fancy]
        user.favorite_quote = params[:favorite_quote]
        user.secret_quality = params[:secret_quality]
        user.save!
        redirect "/sessions/new"
    end

    # User show page. Two instance variables. (The alphabetization of username does not seem to have worked. )
    get '/:id' do
        @user = User.find(params[:id])
        @users = User.order(:username)
        erb :'/users/show'
    end

    # form to edit a user
    get '/:id/edit' do
        @user = User.find(params[:id])
        erb :'/users/edit'
    end

    # store info for edited user, redirect to user's homepage.
    patch '/:id' do
        user = User.find(params[:id])
        user.update(params[:user])
        if params[:new_password].length > 1
            user.password=params[:new_password]
            user.save!
        end
        redirect "/users/#{user.id}"
    end

    # delete a user.  Buggy!
    delete '/:id' do
        user = User.find(params[:id])
        user.delete
        binding.pry
        redirect '/'
    end

end
