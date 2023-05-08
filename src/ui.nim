# Functions for drawing to terminal on certain events
# Parameters will be passed in from main file based on transaction result
var preFormatted = false;

proc printBody*(lines: seq[string])
proc clearScreen*()
proc textLine(line: string)
proc headerLine(line: string, size: int)
proc listLine(line: string)
proc quoteLine(line: string)
proc textLine(line: string)
proc preFormattedLine(line: string)
proc blankLine()

proc printBody*(lines: seq[string]) =
   
    for line: string in lines:
        block outer:
            if line.len < 1:
                blankLine()
                break outer
            if line[0..2] == "```":
                preFormatted = not preFormatted
                break outer
            if preFomatted:
                preFormattedLine(line)
                break outer

            case line[0]:
                of "=":
                    if line[0..2] == "=> ":
                        linkLine(line)
                    else:
                        textLine(line)
                of "#":
                    if line[1] == "#":
                        if line[2] == "#":
                            headerLine(line, 3)
                        else:
                            headerLine(line, 2)
                    else:
                        headerLine(line, 1)
                of "*":
                    listLine(line)
                of ">":
                    quoteLine(line)
                else:
                    textLine(line)


