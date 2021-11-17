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

inductive Layer
  | foreground
  | background
  deriving DecidableEq

export Layer (foreground background)

private def singleValue (v : String) (layer : Layer) : Csi := if layer = foreground then ⟨ s!"38;5;{v}m" ⟩ else ⟨ s!"48;5;{v}m" ⟩

def black         (layer : Layer := foreground) : Csi := singleValue  "0" layer
def red           (layer : Layer := foreground) : Csi := singleValue  "1" layer
def green         (layer : Layer := foreground) : Csi := singleValue  "2" layer
def yellow        (layer : Layer := foreground) : Csi := singleValue  "3" layer
def blue          (layer : Layer := foreground) : Csi := singleValue  "4" layer
def magenta       (layer : Layer := foreground) : Csi := singleValue  "5" layer
def cyan          (layer : Layer := foreground) : Csi := singleValue  "6" layer
def white         (layer : Layer := foreground) : Csi := singleValue  "7" layer
def lightBlack    (layer : Layer := foreground) : Csi := singleValue  "8" layer
def lightRed      (layer : Layer := foreground) : Csi := singleValue  "9" layer
def lightGreen    (layer : Layer := foreground) : Csi := singleValue "10" layer
def lightYellow   (layer : Layer := foreground) : Csi := singleValue "11" layer
def lightBlue     (layer : Layer := foreground) : Csi := singleValue "12" layer
def lightMagenta  (layer : Layer := foreground) : Csi := singleValue "13" layer
def lightCyan     (layer : Layer := foreground) : Csi := singleValue "14" layer
def lightWhite    (layer : Layer := foreground) : Csi := singleValue "15" layer

def reset (layer : Layer := foreground) : Csi := if layer = foreground then ⟨ "39m" ⟩ else  ⟨ "49m" ⟩ 

def black'          : Csi := black background
def red'            : Csi := red background
def green'          : Csi := green background
def yellow'         : Csi := yellow background
def blue'           : Csi := blue background
def magenta'        : Csi := magenta background
def cyan'           : Csi := cyan background
def white'          : Csi := white background
def lightBlack'     : Csi := lightBlack background
def lightRed'       : Csi := lightRed background
def lightGreen'     : Csi := lightGreen background
def lightYellow'    : Csi := lightYellow background
def lightBlue'      : Csi := lightBlue background
def lightMagenta'   : Csi := lightMagenta background
def lightCyan'      : Csi := lightCyan background
def lightWhite'     : Csi := lightWhite background
def reset'          : Csi := reset background

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