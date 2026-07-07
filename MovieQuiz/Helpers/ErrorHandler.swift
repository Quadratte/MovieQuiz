import Foundation

struct ErrorHandler {

    static func getUserFriendlyMessage(from error: Error) -> String {
        let nsError = error as NSError

        switch nsError.code {
        case NSURLErrorNotConnectedToInternet:
            return "Нет интернет-соединения"
        case NSURLErrorTimedOut:
            return "Превышено время ожидания ответа от сервера"
        case NSURLErrorCannotFindHost, NSURLErrorCannotConnectToHost:
            return "Не удаётся подключиться к серверу"
        case NSURLErrorNetworkConnectionLost:
            return "Соединение потеряно"
        case NSURLErrorSecureConnectionFailed:
            return "Ошибка защищённого соединения"
        case NSURLErrorBadURL:
            return "Некорректный адрес сервера"
        case NSURLErrorBadServerResponse:
            return "Некорректный ответ от сервера"
        default:
            if nsError.domain == "APIError" {
                return nsError.localizedDescription
            }
        }

        if nsError.domain == "NSCocoaErrorDomain" && nsError.code == 3840 {
            return "Ошибка обработки данных"
        }

        return "Не удалось загрузить данные. Попробуйте еще раз."
    }
}

