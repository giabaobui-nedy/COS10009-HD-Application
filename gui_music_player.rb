require 'gosu'
require './loadfiles/file_loader.rb'
require './area_creation/area_creation.rb'
require './objects/objects.rb'
require './button_logic/button_logic.rb'
WIDTH = 840
HEIGHT = 700
TOP_COLOR = Gosu::Color.new(0xFF1EB1FA)
BOTTOM_COLOR = Gosu::Color.new(0xFF1D4DB5)
ALBUM_SIZE = 200
TRACK_SIZE = 50
ALBUM_PER_PAGE = 9
TRACK_PER_PAGE = 12

module ZOrder
  BACKGROUND, PLAYER, UI, WIDGET = *0..3
end

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

GENRE_NAMES = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class MusicPlayerMain < Gosu::Window

	def initialize
	    super WIDTH, HEIGHT
      self.caption = "Music Player"
        @music_file = "musicfile.txt"
        #text field
        # Reads in an array of albums from a file
        @albums = read_albums_main(@music_file)
        # current album/track
        @playing_album = nil
        @playing_track = nil
        # uninitialized track areas
        @tracks_area = nil
        #print the tracks' names
        @TrackLeftX = 620
        @TrackRightX = 820
        @font_size = 16
        @track_font = Gosu::Font.new(@font_size)
        @albums_area = create_albums_area()
        #initialize play/pause button
        @button_areas = Array.new()
        #initialize button images (play/pause buttons)
        @play_button = Gosu::Image.new("buttons/play_button.png")
        @pause_button = Gosu::Image.new("buttons/pause_button.png")
        @shuffle_button = Gosu::Image.new("buttons/shuffle_button.png")
        @next_button = Gosu::Image.new("buttons/next_button.png")
        @previous_button = Gosu::Image.new("buttons/previous_button.png")
        @shuffle_button_clicked = Gosu::Image.new("buttons/shuffle_button_clicked.png")
        @loop_button =  Gosu::Image.new("buttons/loop_button.png")
        @loop_button_selected =  Gosu::Image.new("buttons/loop_button_selected.png")
        @album_pageup = Gosu::Image.new("buttons/page_up.png")
        @album_pagedown = Gosu::Image.new("buttons/page_down.png")
        @track_pageup = Gosu::Image.new("buttons/page_up.png")
        @track_pagedown = Gosu::Image.new("buttons/page_down.png")
        #declare button areas in the music player
        @next_button_area = Area.new(300-25,(600+50)-25, (300-25)+50, (600+50)+25)
        @play_pause_button_area = Area.new(300-25-50, (600+50)-25, 300-25, (600+50)+25)
        @loop_button_area = Area.new(300-25+50, (600+50)-25, (300-25)+ 100, (600+50)+25)
        @previous_button_area = Area.new(300-25-100,(600+50)-25, 300-25-50, (600+50)+25)
        @shuffle_button_area = Area.new(300-25-150,(600+50)-22, 300-25-100, (600+50)+22)
        @album_pageup_area = Area.new(600, 0, 620, 20)
        @album_pagedown_area = Area.new(600, 600-20, 620, 600)
        @track_pageup_area = Area.new(840-20, 0, 840, 20)
        @track_pagedown_area = Area.new(840-20, 600-20, 840, 600)
        #append areas to the buttons' array
        @button_areas << @play_pause_button_area #0
        @button_areas << @shuffle_button_area #1
        @button_areas << @next_button_area #2
        @button_areas << @previous_button_area #3
        @button_areas << @loop_button_area #4
        @button_areas << @album_pageup_area #5
        @button_areas << @album_pagedown_area #6
        @button_areas << @track_pageup_area #7
        @button_areas << @track_pagedown_area #8
        #variable for the button
        # FOR THE PLAY/PAUSE BUTTON
        @playing = true
        #FOR THE SHUFFLE MODE BUTTON
        @shuffle = false
        #FOR NEXT/PREVIOUS BUTTON
        @next_song = false
        @previous_song = false
        #FOR LOOP BUTTON
        @song_loop = false
        #initialize pages
        # because there will always an album so the page would be 1 so that the first page will be displayed as the users use the music player
        @current_album_page = 1
        # pages for tracks will be created later
        @current_track_page = nil
        #number of album pages
        @number_of_album_page = calculate_pages_for_album(@albums.length)
        #the exact number of tracks pages will be evaluated later in the event that an album is clicked
        @number_of_track_page = nil
  end
  

    def calculate_pages_for_album(number_of_album)
        number_of_pages = nil
        if number_of_album % ALBUM_PER_PAGE == 0
            number_of_pages = number_of_album / ALBUM_PER_PAGE
        else
            number_of_pages = (number_of_album/ ALBUM_PER_PAGE).round() + 1
        end
        return number_of_pages
    end
  # Draws the artwork on the screen for all the albums
    def draw_albums (albums)
        index = 0
        row = 0
        while index < albums.length
            if albums[index].page == @current_album_page
                if index % 3 == 0
                    artwork = ArtWork.new(albums[index].artwork)
                    artwork.bmp.draw(0, row*ALBUM_SIZE, ZOrder::UI, 1)
                elsif index % 3 == 1
                    artwork = ArtWork.new(albums[index].artwork)
                    artwork.bmp.draw(ALBUM_SIZE, row*ALBUM_SIZE, ZOrder::UI, 1)
                elsif index % 3 == 2
                    artwork = ArtWork.new(albums[index].artwork)
                    artwork.bmp.draw(ALBUM_SIZE*2, row*ALBUM_SIZE, ZOrder::UI, 1)
                    row += 1
                end
                index += 1
            else
                index += 1
            end
        end
    end

  # Takes a String title and an Integer ypos
  # You may want to use the following:
    def display_track(album, ypos)
        index = 0
        row = 0
        while index < album.tracks.length
            if album.tracks[index].page == @current_track_page
                if album.tracks[index].is_playing == true
                    @track_font.draw(album.tracks[index].title + "is playing...", @TrackLeftX, (row*ypos)+(ypos/2-@font_size/2), ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::BLACK)
                else
                    @track_font.draw(album.tracks[index].title, @TrackLeftX, (row*ypos)+(ypos/2-@font_size/2), ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::WHITE)
                end
                index += 1
                row += 1
            else
                index += 1
                row = 0
            end
        end
    end

  # Takes a track index and an Album and plays the Track from the Album
    def playTrack(track, album)
        @song = Gosu::Song.new(album.tracks[track].location.to_s.chomp)
        @song.play(false)
    end

    # returns the area clicked
    def calculate_clicked_area(areas, mouse_x, mouse_y)
        area = nil
        if areas != nil
            for i in 0..(areas.length-1)
                if (areas[i].page != nil)
                    if (areas[i].page == @current_album_page) && mouse_x < 600
                        if (areas[i].leftX < mouse_x) && (mouse_x < areas[i].rightX) && (areas[i].topY < mouse_y) && (mouse_y < areas[i].bottomY)
                            area = i
                        end
                    elsif (areas[i].page == @current_track_page) && mouse_x > 600
                        if (areas[i].leftX < mouse_x) && (mouse_x < areas[i].rightX) && (areas[i].topY < mouse_y) && (mouse_y < areas[i].bottomY)
                            area = i
                        end
                    end
                else
                    if (areas[i].leftX < mouse_x) && (mouse_x < areas[i].rightX) && (areas[i].topY < mouse_y) && (mouse_y < areas[i].bottomY)
                        area = i
                    end
                end
            end
        end
        return area
    end
    # Draw a coloured background using TOP_COLOR and BOTTOM_COLOR

  def draw_background
        draw_quad(0, 0, TOP_COLOR, WIDTH, 0, TOP_COLOR, 0, HEIGHT, BOTTOM_COLOR, WIDTH, HEIGHT, BOTTOM_COLOR, ZOrder::BACKGROUND)
  end

    def draw_button
        #draw playing and pause button
        if @playing
            @play_button.draw(300-25-50, (600+50)-25, ZOrder::UI, 1)
        else
            @pause_button.draw(300-25-50, (600+50)-25, ZOrder::UI, 1)
        end
        #draw shuffle mode button
        if !@shuffle
            @shuffle_button.draw(300-25-150,(600+50)-25, ZOrder::UI, 1)
        else
            @shuffle_button_clicked.draw(300-25-150,(600+50)-25, ZOrder::UI, 1)
        end
        #draw next/previous button
        @next_button.draw(300-25, (600+50)-25, ZOrder::UI, 1)
        @previous_button.draw(300-25-100,(600+50)-25, ZOrder::UI, 1)
        #draw loop button
        if !@song_loop
            @loop_button.draw(300-25+50,(600+50)-22, ZOrder::UI, 1)
        else
            @loop_button_selected.draw(300-25+50,(600+50)-22, ZOrder::UI, 1)
        end
        #draw_pageup_pagedown button (for albums/tracks pagination)
        @album_pageup.draw(600, 0, ZOrder::UI, 1)
        @album_pagedown.draw(600, 600-20, ZOrder::UI, 1)
        @track_pageup.draw(840-20, 0,ZOrder::UI, 1)
        @track_pagedown.draw(840-20, 600-20, ZOrder::UI, 1)
    end




# Not used? Everything depends on mouse actions.

	def update
    if (@playing_album != nil)
        if (@playing_track != nil)
            if !@song_loop
                if !@shuffle
                    # this is autoplay (index += 1) mode
                    if !@song.playing? && !@song.paused?
                        @albums[@playing_album].tracks[@playing_track].is_playing = false
                        @playing_track += 1
                        @playing_track = @playing_track % @albums[@playing_album].tracks.length
                        @albums[@playing_album].tracks[@playing_track].is_playing = true
                        playTrack(@playing_track, @albums[@playing_album])
                    end
                else
                    if !@song.playing? && !@song.paused?
                        @albums[@playing_album].tracks[@playing_track].is_playing = false
                        @playing_track += rand(0..@albums[@playing_album].tracks.length)
                        @playing_track += 1
                        @playing_track = @playing_track % @albums[@playing_album].tracks.length
                        @albums[@playing_album].tracks[@playing_track].is_playing = true
                        playTrack(@playing_track, @albums[@playing_album])
                    end
                end
            else
                if !@song.playing? && !@song.paused?
                    playTrack(@playing_track, @albums[@playing_album])
                end
            end

            if @next_song
                @albums[@playing_album].tracks[@playing_track].is_playing = false
                @playing_track += 1
                @playing_track = @playing_track % @albums[@playing_album].tracks.length
                @albums[@playing_album].tracks[@playing_track].is_playing = true
                playTrack(@playing_track, @albums[@playing_album])
                @next_song = false
            end

            if @previous_song
                @albums[@playing_album].tracks[@playing_track].is_playing = false
                @playing_track -= 1
                @playing_track = @playing_track % @albums[@playing_album].tracks.length
                @albums[@playing_album].tracks[@playing_track].is_playing = true
                playTrack(@playing_track, @albums[@playing_album])
                @previous_song = false
            end

        end
    end
	end

 # Draws the album images and the track list for the selected album

	def draw
    draw_background
    draw_button
    draw_albums(@albums)
    if (@playing_album != nil)
        display_track(@albums[@playing_album], TRACK_SIZE)
    end
	end




 	def needs_cursor?;
        true;
    end

    def handle_button_click(button_id)
        case button_id
        when 0
            handle_play_pause
        when 1
            handle_shuffle
        when 2
            handle_next_button
        when 3
            handle_previous_button
        when 4
            handle_loop_button
        when 5
            handle_album_pageup
        when 6
            handle_album_pagedown
        when 7
            handle_track_pageup
        when 8
            handle_track_pagedown
        end
    end

	def button_down(id)
        album_id = nil
        track_id = nil
        button_id = nil
		case id
        when Gosu::MsLeft
        #For the selecting album in the albums list
            # to determine which is the selected album
            album_id = calculate_clicked_area(@albums_area, mouse_x, mouse_y)
            # whether you have clicked on the album area
            if (album_id != nil)
                # check whether there is no current playing album
                if (@playing_album == nil)
                    @playing_album = album_id
                # now the playing album would be the one which we have selected
                else
                    # check if we have clicked on the same album
                    if (@playing_album == album_id)
                    # if we did not click on the same album
                    else
                        # Reset all values of current album and current track
                        @albums[@playing_album].selected = false
                        # if there is a track playing
                        if (@playing_track != nil)
                            # stop the track from playing
                            @albums[@playing_album].tracks[@playing_track].is_playing = false
                        end
                        # Set the new selected album
                        @playing_album = album_id
                        @albums[@playing_album].selected = true
                    end
                end

                # Set the playing track to 0
                if  @albums[@playing_album].tracks[0] != nil
                    #automatically open page 1
                    @current_track_page = 1
                    #automatically play the first track
                    @playing_track = 0
                    @albums[@playing_album].tracks[@playing_track].is_playing = true
                    playTrack(@playing_track, @albums[@playing_album])
                    # Initialize track areas for playing album
                    @tracks_area = create_tracks_area(@albums[@playing_album])
                    @number_of_track_page = @albums[@playing_album].tracks.length / TRACK_PER_PAGE
                    if @albums[@playing_album].tracks.length % TRACK_PER_PAGE != 0
                        @number_of_track_page += 1
                    end
                else
                    if @song != nil
                        @song.stop()
                        @playing_track = nil
                    end
                end
            end

            # For the selecting track in the tracks list
            track_id = calculate_clicked_area(@tracks_area, mouse_x, mouse_y)
            if (track_id != nil)
                if (@playing_track != track_id)
                    # refresh the current playing track
                    @albums[@playing_album].tracks[@playing_track].is_playing = false
                    # set the current playing track
                    @playing_track = track_id
                    @albums[@playing_album].tracks[@playing_track].is_playing = true
                    playTrack(@playing_track, @albums[@playing_album])
                end
            end

            # Interact with buttons
            button_id = calculate_clicked_area(@button_areas, mouse_x, mouse_y)
            if (button_id != nil)
                handle_button_click(button_id)
            end

        end
	end
end

# Show is a method that loops through update and draw

MusicPlayerMain.new.show if __FILE__ == $0