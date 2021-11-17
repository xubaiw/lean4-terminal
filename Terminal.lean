namespace Terminal

structure Csi where
  value : String

def Csi.toString (csi : Csi) : String := "\x1B[" ++ csi.value

instance : ToString Csi := ⟨ Csi.toString ⟩

namespace Clear

def all : Csi := ⟨ "2J" ⟩
def afterCursor : Csi := ⟨ "J" ⟩
def beforeCursor : Csi := ⟨ "1J" ⟩
def currentLine : Csi := ⟨ "2K" ⟩
def untilNewline : Csi := ⟨ "K" ⟩

end Clear

namespace Color

structure Color where
  fg : Csi
  bg : Csi

def fg (c : Color) : Csi := c.fg
def bg (c : Color) : Csi := c.bg

def Color.singleValue (v : String) : Color := ⟨ ⟨ s!"38;5;{v}m" ⟩, ⟨ s!"48;5;{v}m" ⟩ ⟩ 

def black         : Color := Color.singleValue "0"
def red           : Color := Color.singleValue "1"
def green         : Color := Color.singleValue "2"
def yellow        : Color := Color.singleValue "3"
def blue          : Color := Color.singleValue "4"
def magenta       : Color := Color.singleValue "5"
def cyan          : Color := Color.singleValue "6"
def white         : Color := Color.singleValue "7"
def lightBlack    : Color := Color.singleValue "8"
def lightRed      : Color := Color.singleValue "9"
def lightGreen    : Color := Color.singleValue "10"
def lightYellow   : Color := Color.singleValue "11"
def lightBlue     : Color := Color.singleValue "12"
def lightMagenta  : Color := Color.singleValue "13"
def lightCyan     : Color := Color.singleValue "14"
def lightWhite    : Color := Color.singleValue "15"

def reset : Color := ⟨ ⟨ "39m" ⟩, ⟨ "49m" ⟩ ⟩ 

end Color

namespace Cursor

def hide : Csi := ⟨ "?25l" ⟩ 
def «show» : Csi := ⟨ "?25h" ⟩ 
def restore : Csi := ⟨ "u" ⟩ 
def save : Csi := ⟨ "s" ⟩ 
def blinkingBlock : Csi := ⟨ "\x31 q" ⟩ 
def steadyBlock : Csi := ⟨ "\x32 q" ⟩ 
def blinkingUnderline : Csi := ⟨ "\x33 q" ⟩ 
def steadyUnderline : Csi := ⟨ "\x34 q" ⟩ 
def blinkingBar : Csi := ⟨ "\x35 q" ⟩ 
def steadyBar : Csi := ⟨ "\x36 q" ⟩ 

end Cursor

namespace Screen

def toMainScreen : Csi := ⟨ "?1049l" ⟩ 
def toAlternateScreen : Csi := ⟨ "?1049h" ⟩ 

end Screen

namespace Scroll

def up    (n : UInt16) : Csi := ⟨ s!"{n}S" ⟩ 
def down  (n : UInt16) : Csi := ⟨ s!"{n}T" ⟩ 

end Scroll

namespace Style

def reset         : Csi := ⟨ "m" ⟩ 
def bold          : Csi := ⟨ "1m" ⟩ 
def faint         : Csi := ⟨ "2m" ⟩ 
def italic        : Csi := ⟨ "3m" ⟩ 
def underline     : Csi := ⟨ "4m" ⟩ 
def blink         : Csi := ⟨ "5m" ⟩ 
def invert        : Csi := ⟨ "7m" ⟩ 
def crossedOut    : Csi := ⟨ "9m" ⟩ 
def noBold        : Csi := ⟨ "21m" ⟩ 
def noFaint       : Csi := ⟨ "22m" ⟩ 
def noItalic      : Csi := ⟨ "23m" ⟩ 
def noUnderline   : Csi := ⟨ "24m" ⟩ 
def noBlink       : Csi := ⟨ "25m" ⟩ 
def noInvert      : Csi := ⟨ "27m" ⟩ 
def noCrossedOut  : Csi := ⟨ "29m" ⟩ 
def framed        : Csi := ⟨ "51m" ⟩ 

end Style

end Terminal