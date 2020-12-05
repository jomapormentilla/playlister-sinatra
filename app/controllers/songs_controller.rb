require 'rack-flash'

class SongsController < ApplicationController
    use Rack::Flash
    
    get '/songs' do
        @songs = Song.all
        erb :'songs/index'
    end

    get '/songs/new' do
        @artists = Artist.all
        @genres = Genre.all
        erb :'songs/new'
    end

    get '/songs/:slug' do
        @song = Song.find_by_slug(params[:slug])
        erb :'songs/show'
    end

    get '/songs/:slug/edit' do
        @song = Song.find_by_slug(params[:slug])
        @artists = Artist.all
        @genres = Genre.all
        erb :'songs/edit'
    end

    post '/songs' do
        song = Song.create(params[:song])

        artist = Artist.find_or_create_by(params[:artist])
        song.artist = artist

        if params[:song][:genre_ids] != nil
            params[:song][:genre_ids].each do |genre|
                genre = Genre.find_by_id(genre.to_i)
                song.genres << genre
            end
        else
            song.genres = []
        end

        song.save

        flash[:message] = "Successfully created song."
        redirect "/songs/#{ song.slug }"
    end

    patch '/songs/:slug' do
        song = Song.find_by_slug(params[:slug])

        if params[:artist][:name] != ""
            artist = Artist.create(name: params[:artist][:name])
        else
            artist = Artist.find_by_id(params[:artist][:id][0])
        end
        song.update(artist: artist)

        if params[:song][:genre_ids] != nil
            params[:song][:genre_ids].each do |genre|
                genre = Genre.find_by_id(genre.to_i)
                if !song.genres.include?(genre)
                    song.genres << genre
                end
            end
        else
            song.genres = []
        end

        flash[:message] = "Successfully updated song."
        redirect "/songs/#{ song.slug }"
    end
end
