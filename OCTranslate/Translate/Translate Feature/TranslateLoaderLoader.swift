//
//  TranslateLoader.swift
//  OCTranslate
//
//  Created by Christophe Bugnon on 17/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

public enum LoadTranslateResult<U> {
    case success(U)
    case failure(Error)
}

public protocol TranslateLoader {
    func load(completion: @escaping (LoadTranslateResult<TranslateModel>) -> Void)
}
