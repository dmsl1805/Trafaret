import Foundation

func `catch`(_ `do`: () throws -> Void) -> Error? {
    do {
        try `do`()
        return nil
    } catch {
        return error
    }
}

func `catch`<T>(_ `do`: () throws -> T) -> Result<T, Error> {
    do {
        return .success(try `do`())
    } catch {
        return .failure(error)
    }
}
