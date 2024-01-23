//
//  NetworkServiceProtocol.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 23/01/24.
//

import Foundation

protocol NetworkServiceProtocol {
    func createAppKey(completion: @escaping (Result<AppKeyResponseModel, NetworkError>) -> Void)
}
