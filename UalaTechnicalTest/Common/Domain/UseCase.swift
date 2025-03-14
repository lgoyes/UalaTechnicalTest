//
//  UseCase.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

protocol Command {
    associatedtype ErrorType: Swift.Error
    func execute() async throws(ErrorType)
}

protocol Resultable {
    associatedtype Output
    func getResult() throws -> Output
}

typealias UseCase = Command & Resultable
