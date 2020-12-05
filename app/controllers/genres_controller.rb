class GenresController < ApplicationController
    get '/genres' do
        @genres = Genre.all
        erb :'genres/index'
    end

    get '/genres/new' do
        erb :'genres/new'
    end

    get '/genres/:slug' do
        @genre = Genre.find_by_slug(params[:slug])
        erb :'genres/show'
    end

    get '/genres/:id/edit' do
        @genre = Genre.find_by_id(params[:id])
        erb :'genres/edit'
    end
end
