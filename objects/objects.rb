require 'gosu'
class ArtWork

  attr_accessor :bmp

  def initialize (file)
    @bmp = Gosu::Image.new(file)
  end

end

# Put your record definitions here

class Album

  attr_accessor :title, :artist, :artwork, :tracks, :selected, :page

  def initialize (title, artist, artwork, tracks, selected = false)
    @title = title
    @artist = artist
    @artwork = artwork
    @tracks = tracks
    @selected = selected
  end


end

class Track

  attr_accessor :title, :location, :is_playing, :page

  def initialize (title, location)
    @title = title
    @location = location
    @is_playing = is_playing
  end
end

class Area
  attr_accessor :leftX, :topY, :rightX, :bottomY, :page

  def initialize(leftX, topY, rightX, bottomY, page = nil)
    @leftX = leftX
    @topY = topY
    @rightX = rightX
    @bottomY = bottomY
    @page = page
  end
  #FOR Troubleshooting PURPOSES
  # def print_attribute
  #   puts(@leftX)
  #   puts(@topY)
  #   puts(@rightX)
  #   puts(@bottomY)
  #   puts(@page)
  # end
end

class User_Input < Gosu::TextInput
  INACTIVE_COLOR  = 0xcc666666
  ACTIVE_COLOR    = 0xccff6666
  SELECTION_COLOR = 0xcc0000ff
  CARET_COLOR     = 0xffffffff
  PADDING = 5
  #all the attributes initialize when a new instance created
  attr_accessor :x, :y
  def initialize(window, font, x, y)
    super()
    @window = window
    @font = font
    @x = x
    @y = y
    self.text = "Enter playlist's name..."
    @maximum_word = 25

  end

  def get_text
    self.text
  end

  def draw
    puts(self.caret_pos)
    puts("----")
    puts(@font.text_width(self.text))
    # Depending on whether this is the currently selected input or not, change the
    # background's color.
    if @window.text_input == self
      background_color = ACTIVE_COLOR
    else
      background_color = INACTIVE_COLOR
    end

    @window.draw_quad(x - PADDING,         y - PADDING,          background_color,
                      x + width + PADDING, y - PADDING,          background_color,
                      x - PADDING,         y + height + PADDING, background_color,
                      x + width + PADDING, y + height + PADDING, background_color, 0)

    # Calculate the position of the caret and the selection start.
    if self.caret_pos < @maximum_word
      pos_x = x + @font.text_width(self.text[0...self.caret_pos])
      sel_x = x + @font.text_width(self.text[0...self.selection_start])
    end

    # Draw the selection background, if any; if not, sel_x and pos_x will be
    # the same value, making this quad empty.
    @window.draw_quad(sel_x, y,          SELECTION_COLOR,
                      pos_x, y,          SELECTION_COLOR,
                      sel_x, y + height, SELECTION_COLOR,
                      pos_x, y + height, SELECTION_COLOR, 0)

    # Draw the caret; again, only if this is the currently selected field.
    if @window.text_input == self
      @window.draw_line(pos_x, y,          CARET_COLOR,
                        pos_x, y + height, CARET_COLOR, 0)
    end

    # Finally, draw the text itself!
    @font.draw(self.text, x, y, 0)
  end

  def width
    @font.text_width(self.text)
  end

  def height
    @font.height
  end

  # Hit-test for selecting a text field with the mouse.
  def under_point?(mouse_x, mouse_y)
      mouse_x > x - PADDING and mouse_x < x + width + PADDING and mouse_y > y - PADDING and mouse_y < y + height + PADDING
  end

  # Tries to move the caret to the position specifies by mouse_x
  def move_caret(mouse_x)
    # Test character by character
    1.upto(self.text.length) do |i|
      if mouse_x < x + @font.text_width(text[0...i])
        self.caret_pos = self.selection_start = i - 1
        return
      end
    end
    # Default case: user must have clicked the right edge
    self.caret_pos = self.selection_start = self.text.length
  end

end
