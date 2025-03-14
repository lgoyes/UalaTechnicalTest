//
//  Logger.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 14/3/25.
//

enum LogLevel {
    case info, warning, error
}

protocol Logger {
    func log(_ message: String, level: LogLevel)
}
