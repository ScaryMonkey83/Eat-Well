//
//  Colors.swift
//  Noms
//
//  Created by Jacob Lehn Detwiler on 11/3/23.
//

import Foundation
import SwiftUI


extension ColorScheme {
    var primary: Color {
        return self == .dark ? Color(red: 236/255, green: 254/255, blue: 170/255) : Color(red: 236/255, green: 254/255, blue: 170/255)
    }
    
    var secondary: Color {
        return self == .dark ? Color(red: 226/255, green: 222/255, blue: 132/255) : Color(red: 226/255, green: 222/255, blue: 132/255)
    }
    
    var tertiary: Color {
        return self == .dark ? Color(red: 104/255, green: 131/255, blue: 186/255) : Color(red: 104/255, green: 131/255, blue: 186/255)
    }
    
    var accent: Color {
        return self == .dark ? .white : .black
    }
    
    var background: Color {
        return self == .dark ? .black : Color(red: 118/255, green: 117/255, blue: 34/255)
    }
    
    var blkOrWht: Color {
        return self == .dark ? .black : .white
    }
    
    var blkOrWhtInverse : Color {
        return self == .dark ? .white : .black
    }
}
