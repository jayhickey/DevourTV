//  
//  Devour
//
//  Copyright © 2017 Jay Hickey. All rights reserved.
//

import Foundation

func decode<T: Decodable>(with data: Data, keyPath: String, responseType: [T].Type) -> [T]? {
    do {
        let serializedData = try jsonData(with: data, keyPath: keyPath)
        let decoded = try jsonDecoder.decode(responseType, from: serializedData)
        return decoded
    } catch {
        print(error)
        return nil
    }
}

// MARK: Private

private let jsonDecoder = { () -> JSONDecoder in
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return decoder
}()


private enum KeyPathError: Error {
    case invalidKeypath
}

private func jsonData(with data: Data, keyPath: String) throws -> Data {
    do {
        let json = try JSONSerialization.jsonObject(with: data)
        guard let jsonDict = json as? NSDictionary,
            let keypathObject = jsonDict.value(forKeyPath: keyPath),
            !(keypathObject is NSNull) else {
                throw KeyPathError.invalidKeypath
        }
        guard let array = keypathObject as? Array<Dictionary<String, Any>> else { return Data() }
        return try JSONSerialization.data(withJSONObject: removeEmptyStringValues(dict: array))
    } catch {
        throw error
    }
}

private func removeEmptyStringValues(dict array: Array<Dictionary<String, Any>>) -> Array<Dictionary<String, Any>> {
    var newArray: Array<Dictionary<String, Any>> = []
    for dict in array {
        var mutableDict = dict
        for key in dict.keys {
            if dict[key] as? String == "" {
                mutableDict.removeValue(forKey: key)
            }
        }
        newArray.append(mutableDict)
    }
    return newArray
}
