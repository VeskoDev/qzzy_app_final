//
//  Text+Multiline.swift
//  qzzy_app_final
//
//  Created by Veselin Lazarevic on 23.4.25..
//

import SwiftUI

extension Text {
    func multiLine(limit: Int = 2) -> some View {
        self
            .lineLimit(limit)
            .fixedSize(horizontal: false, vertical: true)
    }
}
