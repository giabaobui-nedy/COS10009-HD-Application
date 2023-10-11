def create_albums_area
  albums_area = Array.new
  index = 0
  row = 0
  page_count = 1
  while index < @albums.length
    if index % 3 == 0
      album_area = Area.new(0, row*ALBUM_SIZE, ALBUM_SIZE, (row + 1)*ALBUM_SIZE)
      albums_area << album_area
    elsif index % 3 == 1 && index != 0
      album_area = Area.new(ALBUM_SIZE, row*ALBUM_SIZE, ALBUM_SIZE*2, (row + 1)*ALBUM_SIZE)
      albums_area << album_area
    elsif index % 3 == 2 && index != 0
      album_area = Area.new(ALBUM_SIZE*2, row*ALBUM_SIZE, ALBUM_SIZE*3, (row + 1)*ALBUM_SIZE)
      albums_area << album_area
      row += 1
    end
    #assign album areas to pages (e.g: 9 first albums belong to page 1)
    if index == 0
      album_area.page = 1
    else
      if index % 9 == 0
        page_count += 1
      elsif index % 9 == 8
        row = 0
      end
      album_area.page = page_count
    end
    #increment index
    index += 1
  end
  return albums_area
end

def create_tracks_area(album)
  tracks_area = Array.new
  index = 0
  row = 0
  page_count = 1
  while index < album.tracks.length
    track_area = Area.new(@TrackLeftX, row*TRACK_SIZE, @TrackRightX, (row+1)*TRACK_SIZE)
    row += 1
    if index == 0
      track_area.page = 1
    else
      if index % 12 == 0
        page_count += 1
      elsif index % 11 == 0
        row = 0
      end
      track_area.page = page_count
    end
    index += 1
    tracks_area << track_area
  end
  return tracks_area
end

