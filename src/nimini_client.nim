import nimini_lib 
import ui
import std/strutils

#Type declarations
type
    #var example: Input = Input(raw: readLine(stdin))
    #var temp: seq[string] = example.raw.split()
    #example.cmd = temp[0]
    #example.parameters = temp[1..^1]
    Input = tuple  
        raw: string
        cmd: string
        parameters: seq[string]
    ValidCmd = tuple
        valid: bool
        reason: string
       
#Procedure definitions
proc fetch(obj: var TransactionResult, url: string)
proc connect(target: string)
proc getInput(self: var Input)
proc validateInput(self: var Input): ValidCmd
proc links()
proc generateLinks()

#Variable declarations
var client: TransactionResult = TransactionResult()
var input: Input = ("base", "base", @["base"])
var run = true
var linkSequence: seq[string] = @["gemini://gemini.circumlunar.space/", "gemini://geminispace.info/", "gemini://geminiquickst.art/"]
const TESTINGURL = "gemini://gemini.circumlunar.space/"
const cmds: seq[string] = @[
    "connect",
    "help",
    "exit",
    "clear",
    "version",
    "links"
    ]
const help: string = """
NIMINI
connect: connects to gemini url
    usage: "connect gemini://gemini.circumlunar.space/" 
help:    prints this message
    usage: "help"
clear:   clears screen
    usage: "clear"
exit:    exits program
    usage: "exit"
links:   lists available links
    usage: "links"
links X: connects to link number X
    usage: "links 3"
"""
const version: string = r"DEVELOPMENT"

#Main method
when isMainModule:
    clearScreen()
    #[Testing
    client.fetch(TESTINGURL)
    echo client.statusCode #20
    client.fetch(TESTINGURL&"sntensretn")
    echo client.statusCode #51
]#

    while run:
        input.getInput()
        while input.validateInput().valid == false:
            echo input.validateInput().reason
            input.getInput()
        case input.cmd:
            of "connect":
                connect(input.parameters[0])
            of "help":
                echo help
            of "clear":
                clearScreen()
            of "version":
                echo "nimini client version: " & version
            of "links":
                links()
            of "exit":
                run = false
                break
            else:
                echo "Not yet implemented"

        

#Procedure declarations
proc connect(target: string) =
    var targetFixed: string = target
    if targetFixed[0..8] != "gemini://":
        if targetFixed[0] != '/':
            targetFixed = "/" & targetFixed;
        targetFixed = "gemini:/" & targetFixed;

    client.fetch(targetFixed)
    case client.simpleCode:
        of 2:
            printBody(client.responseLines)
            generateLinks()
        of 1:
            echo "No input support yet"
        of 3:
            connect(client.mimeType) #Blindly follow redirects FOR NOW and assume 20x
        of 4:
            echo "Womp, womp, temporary failure"
        of 5:
            echo "Womp, womp, permanent failure"
        of 6:
            echo "Requires a ssl certificate" # Ill do this later, probably never
        else:
            echo "uh oh"

proc generateLinks() = 
    linkSequence = @[];
    for line in client.responseLines:
        var link: string
        if line.len() > 2:
            case line[0..2]:
                of "=> ":
                    var temp: string = line[3..^1].split()[0]
                    link = temp
                    linkSequence.add(link) 
                else:
                    link = ""


proc links() =
    case input.parameters.len():
        of 0:
            echo linkSequence
        of 1:
            connect(linkSequence[input.parameters[0].parseInt()])
        else:
            echo "Too many parameters, view help"

proc fetch(obj: var TransactionResult, url: string) =
    obj.createTransactionResult(transaction(url))

proc getInput(self: var Input) = 
    var userInput: string = readLine(stdin)
    self.raw = userInput
    var temp = userInput.split()
    self.cmd = temp[0]
    self.parameters = temp[1..^1]

proc validateInput(self: var Input): ValidCmd =
    if not (self.cmd in cmds):
        return (false, "Command not found")
    return  (true, "Valid")
    
