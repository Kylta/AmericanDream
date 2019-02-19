//
//  TranslateItem.swift
//  OCTranslate
//
//  Created by Christophe Bugnon on 17/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

public struct TranslateModel: Equatable {
    public let translatedText: String

    public init(translatedText: String) {
        self.translatedText = translatedText
    }
}
