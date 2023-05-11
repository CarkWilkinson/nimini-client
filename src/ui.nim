# Functions for drawing to terminal on certain events
# Parameters will be passed in from main file based on transaction result
var preFormatted = false;

proc printBody*(lines: seq[string])
proc clearScreen*()
proc textLine(line: string)
proc headerLine(line: string, size: int)
proc listLine(line: string)
proc linkLine(line: string)
proc quoteLine(line: string)
proc preFormattedLine(line: string)
proc blankLine()

proc printBody*(lines: seq[string]) =
   
    for line in lines:
        block outer:
            if line.len < 1:
                blankLine()
                break outer
            if line[0..2] == "```":
                preFormatted = not preFormatted
                break outer
            if preFormatted:
                preFormattedLine(line)
                break outer

            case line[0]:
                of '=':
                    if line[0..2] == "=> ":
                        linkLine(line)
                    else:
                        textLine(line)
                of '#':
                    if line[1] == '#':
                        if line[2] == '#':
                            headerLine(line, 3)
                        else:
                            headerLine(line, 2)
                    else:
                        headerLine(line, 1)
                of '*':
                    listLine(line)
                of '>':
                    quoteLine(line)
                else:
                    textLine(line)

proc clearScreen*() =
     echo "\e[2J"
     echo "\e[?7h"
proc textLine(line: string) = 
    echo line
proc headerLine(line: string, size: int) =
    echo line
proc listLine(line: string) =
    echo "*    " & line[1..^1]
proc linkLine(line: string) =
    echo "LINK: \e[4m" & line[3..^1] & "\e[0m"
proc quoteLine(line: string) =
    echo ">    " & line[1..^1]
proc preFormattedLine(line: string) =
    textLine(line)
proc blankLine() =
    echo ""

