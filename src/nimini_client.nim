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

#Variable declarations
var client: TransactionResult = TransactionResult()
var input: Input = ("base", "base", @["base"])
var run = true;
const TESTINGURL = "gemini://gemini.circumlunar.space/"
const cmds: seq[string] = @[
    "connect",
    "help",
    "exit",
    "clear",
    "version"
    ]
const help: string = """
NIMINI
connect: connects to gemini url
    usage: \"connect gemini://gemini.circumlunar.space/\" 
help:    prints this message
    usage: \"help\"
clear:   clears screen
    usage: \"clear\"
exit:    exits program
    usage: \"exit\"
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
            of "exit":
                run = false
                break
            else:
                echo "Not yet implemented"

        

#Procedure declarations
proc connect(target: string) =
    client.fetch(target)
    case client.simpleCode:
        of 2:
            printBody(client.responseLines)
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
    
