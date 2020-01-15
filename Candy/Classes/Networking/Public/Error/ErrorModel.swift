import Foundation

public struct ErrorModel: Error {

    let code: Int
    let message: String

    init(code: Int = 0, message: String) {
        self.code = code
        self.message = message
    }
}
