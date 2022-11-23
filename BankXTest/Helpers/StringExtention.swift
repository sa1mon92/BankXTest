//
//  StringExtention.swift
//  BankHlynovTest
//
//  Created by Дмитрий Садырев on 19.11.2022.
//

import Foundation

extension String {
    func dropHTTPTags() -> String? {
        self.components(separatedBy: "<")[0]
    }
}
