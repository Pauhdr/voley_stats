//
//  SwiftUIView.swift
//
//
//  Created by Pau Hermosilla on 27/4/23.
//

import SwiftUI

struct CustomFonts {
    public static func registerFonts() {
        registerFont(bundle: Bundle.main , fontName: "Neighbor", fontExtension: ".ttf")
        registerFont(bundle: Bundle.main , fontName: "Neighbor-Bold", fontExtension: ".ttf")
        registerFont(bundle: Bundle.main , fontName: "Neighbor-BoldItalic", fontExtension: ".ttf")
        registerFont(bundle: Bundle.main , fontName: "Neighbor-Italic", fontExtension: ".ttf")
        registerFont(bundle: Bundle.main , fontName: "Neighbor-Light", fontExtension: ".ttf")
        registerFont(bundle: Bundle.main , fontName: "Neighbor-LightItalic", fontExtension: ".ttf")
    }
    fileprivate static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider) else {
            fatalError("Couldn't create font from data")
        }
        
        var error: Unmanaged<CFError>?
        
        CTFontManagerRegisterGraphicsFont(font, &error)
    }
}

