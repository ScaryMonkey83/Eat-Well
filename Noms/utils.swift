//
//  utils.swift
//  Noms
//
//  Created by Jacob Lehn Detwiler on 11/7/23.
//

import SwiftUI

func fontSize(_ dynamicSize: DynamicTypeSize) -> CGFloat {
    switch (dynamicSize) {
    case .xSmall:
        return fontSize(.xLarge)
    case .small:
        return fontSize(.xLarge)
    case .medium:
        return fontSize(.xLarge)
    case .large:
        return fontSize(.xLarge)
    case .xLarge:
        return 0.55
    case .xxLarge:
        return 0.6
    case .xxxLarge:
        return 0.65
    case .accessibility1:
        return 0.7
    case .accessibility2:
        return 0.75
    case .accessibility3:
        return 0.8
    case .accessibility4:
        return 0.85
    case .accessibility5:
        return 0.9
    @unknown default:
        return fontSize(.xLarge)
    }
}
