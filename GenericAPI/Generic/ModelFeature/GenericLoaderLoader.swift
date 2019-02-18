//
//  GenericLoader.swift
//  OCWeather
//
//  Created by Christophe Bugnon on 17/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

public enum LoadGenericResult<U> {
    case success(U)
    case failure(Error)
}

public protocol GenericLoader {
    func load(completion: @escaping (LoadGenericResult<GenericModel>) -> Void)
}
