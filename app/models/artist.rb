class Artist < ActiveRecord::Base
    has_many :songs
    has_many :genres, through: :songs

    def slug
        self.name.downcase.gsub(/\W/," ").gsub(/\s+/," ").gsub(" ","-")
    end

    def self.find_by_slug( slug )
        self.all.each do |song|
            if song.slug == slug
                return song
            end
        end
    end
end