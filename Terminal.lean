namespace Terminal

structure Csi where
  value : String

def Csi.toString (csi : Csi) : String := "\x1B[" ++ csi.value

instance : ToString Csi := ⟨ Csi.toString ⟩

namespace Clear

/-- Clear the entire screen. -/
def all           : Csi := ⟨ "2J" ⟩
/-- Clear everything after the cursor. -/
def afterCursor   : Csi := ⟨ "J" ⟩
/-- Clear everything before the cursor. -/
def beforeCursor  : Csi := ⟨ "1J" ⟩
/-- Clear the current line. -/
def currentLine   : Csi := ⟨ "2K" ⟩
/-- Clear from cursor to newline. -/
def untilNewline  : Csi := ⟨ "K" ⟩

end Clear

namespace Color

/-- Choose between foreground and background. -/
inductive Layer
  | foreground
  | background
  deriving DecidableEq

export Layer (foreground background)

/-- An arbitrary ANSI color value. -/
def ansi (v : String) (layer : Layer := foreground) : Csi := if layer = foreground then ⟨ s!"38;5;{v}m" ⟩ else ⟨ s!"48;5;{v}m" ⟩

/-- Black. -/
def black         (layer : Layer := foreground) : Csi := ansi  "0" layer
/-- Red. -/
def red           (layer : Layer := foreground) : Csi := ansi  "1" layer
/-- Green. -/
def green         (layer : Layer := foreground) : Csi := ansi  "2" layer
/-- Yellow. -/
def yellow        (layer : Layer := foreground) : Csi := ansi  "3" layer
/-- Blue. -/
def blue          (layer : Layer := foreground) : Csi := ansi  "4" layer
/-- Magenta. -/
def magenta       (layer : Layer := foreground) : Csi := ansi  "5" layer
/-- Cyan. -/
def cyan          (layer : Layer := foreground) : Csi := ansi  "6" layer
/-- White. -/
def white         (layer : Layer := foreground) : Csi := ansi  "7" layer
/-- High-intensity light black. -/
def lightBlack    (layer : Layer := foreground) : Csi := ansi  "8" layer
/-- High-intensity light red. -/
def lightRed      (layer : Layer := foreground) : Csi := ansi  "9" layer
/-- High-intensity light green. -/
def lightGreen    (layer : Layer := foreground) : Csi := ansi "10" layer
/-- High-intensity light yellow. -/
def lightYellow   (layer : Layer := foreground) : Csi := ansi "11" layer
/-- High-intensity light blue. -/
def lightBlue     (layer : Layer := foreground) : Csi := ansi "12" layer
/-- High-intensity light magenta. -/
def lightMagenta  (layer : Layer := foreground) : Csi := ansi "13" layer
/-- High-intensity light cyan. -/
def lightCyan     (layer : Layer := foreground) : Csi := ansi "14" layer
/-- High-intensity light white. -/
def lightWhite    (layer : Layer := foreground) : Csi := ansi "15" layer

/-- Reset colors to defaults. -/
def reset (layer : Layer := foreground) : Csi := if layer = foreground then ⟨ "39m" ⟩ else  ⟨ "49m" ⟩ 

/-- 216-color (r, g, b ≤ 5) RGB. -/
def ansiRgb (r g b : Fin 5) (layer : Layer := foreground) : Csi := ansi s!"{16 + 36 * r + 6 * g + b}" layer

/-- Grayscale color. -/
def ansiGray (s : Fin 24) (layer : Layer := foreground) : Csi := ansi s!"{0xe8 + s}" layer

/-- A truecolor RGB. -/
def rgb (r g b : UInt8) (layer : Layer := foreground) : Csi := if layer = foreground then ⟨ s!"38;2;{r};{g};{b}m" ⟩ else  ⟨ s!"48;2;{r};{g};{b}m" ⟩ 

/-- Black background. -/
def black'          : Csi := black background
/-- Red background. -/
def red'            : Csi := red background
/-- Green background. -/
def green'          : Csi := green background
/-- Yellow background. -/
def yellow'         : Csi := yellow background
/-- Blue background. -/
def blue'           : Csi := blue background
/-- Magenta background. -/
def magenta'        : Csi := magenta background
/-- Cyan background. -/
def cyan'           : Csi := cyan background
/-- White background. -/
def white'          : Csi := white background
/-- High-intensity light black background. -/
def lightBlack'     : Csi := lightBlack background
/-- High-intensity light red background. -/
def lightRed'       : Csi := lightRed background
/-- High-intensity light green background. -/
def lightGreen'     : Csi := lightGreen background
/-- High-intensity light yellow background. -/
def lightYellow'    : Csi := lightYellow background
/-- High-intensity light blue background. -/
def lightBlue'      : Csi := lightBlue background
/-- High-intensity light magenta background. -/
def lightMagenta'   : Csi := lightMagenta background
/-- High-intensity light cyan background. -/
def lightCyan'      : Csi := lightCyan background
/-- High-intensity light white background. -/
def lightWhite'     : Csi := lightWhite background
/-- Reset background colors to defaults. -/
def reset'          : Csi := reset background

/-- 216-color (r, g, b ≤ 5) RGB background. -/
def ansiRgb' (r g b : Fin 5) : Csi := ansiRgb r g b background

/-- Grayscale color background. -/
def ansiGray' (s : Fin 24) : Csi := ansiGray s background

/-- A truecolor RGB background. -/
def rgb' (r g b : UInt8): Csi := rgb r g b background

end Color

namespace Cursor

/-- Hide the cursor. -/
def hide              : Csi := ⟨ "?25l" ⟩ 
/-- Show the cursor. -/
def «show»            : Csi := ⟨ "?25h" ⟩ 
/-- Restore the cursor. -/
def restore           : Csi := ⟨ "u" ⟩ 
/-- Save the cursor. -/
def save              : Csi := ⟨ "s" ⟩ 
/-- Change the cursor style to blinking block. -/
def blinkingBlock     : Csi := ⟨ "\x31 q" ⟩ 
/-- Change the cursor style to steady block. -/
def steadyBlock       : Csi := ⟨ "\x32 q" ⟩ 
/-- Change the cursor style to blinking underline. -/
def blinkingUnderline : Csi := ⟨ "\x33 q" ⟩ 
/-- Change the cursor style to steady underline. -/
def steadyUnderline   : Csi := ⟨ "\x34 q" ⟩ 
/-- Change the cursor style to blinking bar. -/
def blinkingBar       : Csi := ⟨ "\x35 q" ⟩ 
/-- Change the cursor style to steady bar. -/
def steadyBar         : Csi := ⟨ "\x36 q" ⟩ 

/-- Move cursor up. -/
def up    (n : UInt16) : Csi := ⟨ s!"{n}A" ⟩ 
/-- Move cursor down. -/
def down  (n : UInt16) : Csi := ⟨ s!"{n}B" ⟩ 
/-- Move cursor right. -/
def right (n : UInt16) : Csi := ⟨ s!"{n}C" ⟩ 
/-- Move cursor left. -/
def left  (n : UInt16) : Csi := ⟨ s!"{n}D" ⟩ 

/-- Goto some position ((0,0)-based). -/
def goto (x y : UInt16) : Csi := ⟨ s!"{x+1};{y+1}H" ⟩ 

end Cursor

namespace Screen

/-- Switch to the main screen buffer of the terminal. -/
def toMainScreen      : Csi := ⟨ "?1049l" ⟩ 
/-- Switch to the alternate screen buffer of the terminal. -/
def toAlternateScreen : Csi := ⟨ "?1049h" ⟩ 

end Screen

namespace Scroll

/-- Scroll up. -/
def up    (n : UInt16) : Csi := ⟨ s!"{n}S" ⟩ 
/-- Scroll down. -/
def down  (n : UInt16) : Csi := ⟨ s!"{n}T" ⟩ 

end Scroll

namespace Style

/-- Reset SGR parameters. -/
def reset         : Csi := ⟨ "m" ⟩ 
/-- Bold text. -/
def bold          : Csi := ⟨ "1m" ⟩ 
/-- Fainted text (not widely supported). -/
def faint         : Csi := ⟨ "2m" ⟩ 
/-- Italic text. -/
def italic        : Csi := ⟨ "3m" ⟩ 
/-- Underlined text. -/
def underline     : Csi := ⟨ "4m" ⟩ 
/-- Blinking text (not widely supported). -/
def blink         : Csi := ⟨ "5m" ⟩ 
/-- Inverted colors (negative mode). -/
def invert        : Csi := ⟨ "7m" ⟩ 
/-- Crossed out text (not widely supported). -/
def crossedOut    : Csi := ⟨ "9m" ⟩ 
/-- Undo bold text. -/
def noBold        : Csi := ⟨ "21m" ⟩ 
/-- Undo fainted text (not widely supported). -/
def noFaint       : Csi := ⟨ "22m" ⟩ 
/-- Undo italic text. -/
def noItalic      : Csi := ⟨ "23m" ⟩ 
/-- Undo underlined text. -/
def noUnderline   : Csi := ⟨ "24m" ⟩ 
/-- Undo blinking text (not widely supported). -/
def noBlink       : Csi := ⟨ "25m" ⟩ 
/-- Undo inverted colors (negative mode). -/
def noInvert      : Csi := ⟨ "27m" ⟩ 
/-- Undo crossed out text (not widely supported). -/
def noCrossedOut  : Csi := ⟨ "29m" ⟩ 
/-- Framed text (not widely supported). -/
def framed        : Csi := ⟨ "51m" ⟩ 

end Style

end Terminal