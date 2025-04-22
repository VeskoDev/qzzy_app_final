//
//  StringFormatting.swift
//  qzzy_app_final
//
//  Created by Veselin Lazarevic on 22.4.25..
//

import Foundation

extension String {
    static func formatted(_ value: Double) -> String {
        return String(format: "%.2f", value)
    }
}
