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

namespace Csi

private def singleValue (v : String) (foreground : Bool) : Csi := if foreground then ⟨ s!"38;5;{v}m" ⟩ else ⟨ s!"48;5;{v}m" ⟩

def black         (foreground : Bool := true) : Csi := singleValue  "0" foreground
def red           (foreground : Bool := true) : Csi := singleValue  "1" foreground
def green         (foreground : Bool := true) : Csi := singleValue  "2" foreground
def yellow        (foreground : Bool := true) : Csi := singleValue  "3" foreground
def blue          (foreground : Bool := true) : Csi := singleValue  "4" foreground
def magenta       (foreground : Bool := true) : Csi := singleValue  "5" foreground
def cyan          (foreground : Bool := true) : Csi := singleValue  "6" foreground
def white         (foreground : Bool := true) : Csi := singleValue  "7" foreground
def lightBlack    (foreground : Bool := true) : Csi := singleValue  "8" foreground
def lightRed      (foreground : Bool := true) : Csi := singleValue  "9" foreground
def lightGreen    (foreground : Bool := true) : Csi := singleValue "10" foreground
def lightYellow   (foreground : Bool := true) : Csi := singleValue "11" foreground
def lightBlue     (foreground : Bool := true) : Csi := singleValue "12" foreground
def lightMagenta  (foreground : Bool := true) : Csi := singleValue "13" foreground
def lightCyan     (foreground : Bool := true) : Csi := singleValue "14" foreground
def lightWhite    (foreground : Bool := true) : Csi := singleValue "15" foreground

def reset (foreground : Bool := true) : Csi := if foreground then ⟨ "39m" ⟩ else  ⟨ "49m" ⟩ 

end Csi

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