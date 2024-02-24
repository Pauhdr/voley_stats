//
//  File.swift
//
//
//  Created by Pau Hermosilla on 23/3/23.
//

import Foundation
import SwiftUI
class PDFElement {
    var x:Int
    var y:Int
    var text:String?
    var image:UIImage?
    var font:UIFont?
    var rect: CGRect?
    var type: String
    var shape: String?
    var width: Int?
    var height: Int?
    var color: UIColor?
    var radius: CGFloat = 6
    var fill: Bool = false
    var alignment: NSTextAlignment?
    init(x:Int, y:Int, data:String, font:UIFont, color:UIColor, width: Int?, alignment: NSTextAlignment = .left){
        self.x=x
        self.y=y
        self.text = data
        self.font=font
        self.color=color
        self.width = width
        self.alignment = alignment
        self.type = "text"
    }
    init(x:Int, y:Int, data:UIImage, rect:CGRect){
        self.x=x
        self.y=y
        self.image = data
        self.rect=rect
        self.type = "image"
    }
    init(x:Int, y:Int, width:Int, height:Int, shape:String, color:UIColor, fill:Bool, radius:CGFloat = 6){
        self.x=x
        self.y=y
        self.width=width
        self.height=height
        self.shape=shape
        self.color=color
        self.fill=fill
        self.type = "shape"
        self.radius=radius
    }
    init(){
        self.x=0
        self.y=0
        self.type = "newPage"
    }
}
