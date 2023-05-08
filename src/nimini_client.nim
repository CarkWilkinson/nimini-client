import nimini_lib

proc fetch(obj: var TransactionResult, url: string) =
    obj.createTransactionResult(transaction(url))

var nimini: TransactionResult = TransactionResult()
const TESTINGURL = "gemini://gemini.circumlunar.space/"

when isMainModule:
    nimini.fetch(TESTINGURL)
    echo nimini.statusCode #20
    nimini.fetch(TESTINGURL&"sntensretn")
    echo nimini.statusCode #51
