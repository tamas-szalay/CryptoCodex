enum CCError: Error, Equatable {
    case httpError(Int)
    case genericError(String)
    case jsonParsingError
}
