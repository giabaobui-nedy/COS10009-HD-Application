def print_track(track)
    puts(track.title)
    puts(track.location)
end

def print_tracks(tracks)
    index = 0
    while index < tracks.length
    print_track(tracks[index])
    index += 1
    end
    # print all the tracks use: tracks[x] to access each track.
end

def print_album(album)
    puts(album.title)
    puts(album.artist)
    puts(album.artwork)
    # print out the tracks
    print_tracks(album.tracks)
end

def print_albums(albums)
    index = 0
    while index < albums.length
        print_album(albums[index])
        index += 1
    end
end

def read_track(music_file)
    track = Track.new(music_file.gets, music_file.gets)
    return track
end

def read_tracks(music_file)
    count = music_file.gets().to_i
    # puts(count.to_s)
    tracks = Array.new()
    index = 0
    page_count = 1
    while index < count
        track = read_track(music_file)
        if index == 0
            track.page = 1
        else
            if index % 12 == 0
                page_count += 1
            end
            track.page = page_count
        end
        tracks << track
        index += 1
    end
    return tracks
end

def read_album(music_file)
    album_title = music_file.gets.chomp
    album_artist = music_file.gets.chomp
    album_artwork = music_file.gets.chomp
    tracks = read_tracks(music_file)
    album = Album.new(album_title, album_artist, album_artwork, tracks)
    return album
end

def read_albums(music_file)
    number_of_album = music_file.gets.to_i
    index = 0
    albums = Array.new()
    page_count = 1
    while index < number_of_album
        album = read_album(music_file)
        # assign page value to an album
            if index == 0
                album.page = 1
            else
                if index % 9 == 0
                    page_count += 1
                    album.page = page_count
                elsif index % 9 > 0
                    album.page = page_count
                end
            end
        albums << album
        index += 1
    end
    return albums
end

def read_albums_main(file_name)
    music_file = File.new(file_name, "r")
    albums = read_albums(music_file)
    music_file.close()
    return albums
end