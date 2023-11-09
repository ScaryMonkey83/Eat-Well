//
//  Colors.swift
//  Noms
//
//  Created by Jacob Lehn Detwiler on 11/3/23.
//

import Foundation
import SwiftUI


extension ColorScheme {
    var blkOrWht: Color {
        return self == .dark ? .black : .white
    }
    
    var blkOrWhtInverse : Color {
        return self == .dark ? .white : .black
    }
}
