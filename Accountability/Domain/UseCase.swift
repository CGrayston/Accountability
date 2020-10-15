//
//  UseCase.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/17/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

protocol UseCase {
    associatedtype Request
    associatedtype Response
    
    func execute(request: Request, completion: @escaping (Result<Response, Error>) -> Void)
}

protocol VoidRequestUseCase {
    associatedtype Response
    
    func execute(completion: @escaping (Result<Response, Error>) -> Void)
}

protocol VoidResponseUseCase {
    associatedtype Request
    
    func execute(request: Request, completion: @escaping (Result<Void, Error>) -> Void)
}

protocol VoidUseCase {
    
    func execute(completion: @escaping (Result<Void, Error>) -> Void)
}
