def handle_play_pause
  if (@playing_album != nil)
    if (@playing_track != nil)
      if @playing
        @playing = false
        @albums[@playing_album].tracks[@playing_track].is_playing = false
        @song.pause
      else
        @playing = true
        @albums[@playing_album].tracks[@playing_track].is_playing = true
        @song.play
      end
    end
  end
end

def handle_shuffle
  if (@playing_album != nil)
    if (@playing_track != nil)
      if @shuffle == false
        @shuffle = true
      else
        @shuffle = false
      end
    end
  end
end

def handle_next_button
  if (@playing_album != nil)
    if (@playing_track != nil)
      if @next_song == false
        @next_song = true
      end
    end
  end
end

def handle_previous_button
  if (@playing_album != nil)
    if (@playing_track != nil)
      if @previous_song == false
        @previous_song = true
      end
    end
  end
end

def handle_loop_button
  if @playing_album != nil
    if @playing_track != nil
      if @song_loop == false
        @song_loop = true
      else
        @song_loop = false
      end
    end
  end
end

def handle_album_pageup
  if @current_album_page > 1
    @current_album_page -= 1
  end
end

def handle_album_pagedown
  if @current_album_page < @number_of_album_page
    @current_album_page += 1
  end
end

def handle_track_pageup
  if @current_track_page != nil && @current_track_page > 1
    @current_track_page -= 1
  end
end

def handle_track_pagedown
  if @current_track_page != nil && @current_track_page < @number_of_track_page
    @current_track_page += 1
  end
end

