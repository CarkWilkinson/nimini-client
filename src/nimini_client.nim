import nimini_lib 
import ui

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
proc getInput(self: var Input)
proc validateInput(self: var Input): ValidCmd

#Variable declarations
var client: TransactionResult = TransactionResult()
const TESTINGURL = "gemini://gemini.circumlunar.space/"

#Main method
when isMainModule:
    #Testing
    client.fetch(TESTINGURL)
    echo client.statusCode #20
    client.fetch(TESTINGURL&"sntensretn")
    echo client.statusCode #51

#Procedure declarations
proc fetch(obj: var TransactionResult, url: string) =
    obj.createTransactionResult(transaction(url))

proc getInput(self: var Input) = 
    var userInput: string = readLine(stdin)
    self.raw = userInput
    var temp = userInput.split()
    self.cmd = temp[0]
    self.parameters = temp[1..&1]

proc validateInput(self: var Input): ValidCmd =
    if not (self.cmd in cmds):
        return ValidCmd(valid: false, reason: "Command not found")
    return ValidCmd(valid: true, reason: "Valid")
    
