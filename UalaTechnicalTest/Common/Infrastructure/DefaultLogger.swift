//
//  DefaultLogger.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 14/3/25.
//

class DefaultLogger: Logger {
    typealias LogLevelHandler = (String) -> Void
    private var handlers: [LogLevel: [LogLevelHandler]] = [:]
    
    func registerHandler(for level: LogLevel, handler: @escaping LogLevelHandler) {
        if handlers[level] == nil {
            handlers[level] = []
        }
        handlers[level]!.append(handler)
    }
    
    func log(_ message: String, level: LogLevel) {
        guard let levelHandlers = handlers[level] else {
            return
        }
        levelHandlers.forEach { $0(message) }
    }
}
