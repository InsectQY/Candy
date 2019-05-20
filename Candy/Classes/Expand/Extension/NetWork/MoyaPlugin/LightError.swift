import Moya

public struct LightError: Error {

    public let code: Int
    public let message: String
}

extension Error {

    var errorMessage: String {

        guard
            let error = self as? MoyaError
        else {
            return "未知错误"
        }
        switch error {
        case let .underlying(error, _):
            return error.localizedDescription
        case let .statusCode(response):
            return "\(response.statusCode)错误"
        case let .objectMapping(error, _):
            if let error = error as? LightError {
                return error.message
            }
        default:
            break
        }
        return "未知错误"
    }
}
