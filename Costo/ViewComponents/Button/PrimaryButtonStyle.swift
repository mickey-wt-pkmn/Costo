//
//  PrimaryButtonStyle.swift
//  Costo
//
//  Created by mickey-wp on 2024/03/20.
//

import SwiftUI

struct PrimaryButtonStyleInfo {
    let backgroundColor: Color
    let foregroundColor: Color
    let padding: CGFloat?
    let font: Font
    let fontWeight: Font.Weight
    let minWidth: CGFloat?
    let image: Image?
    
    init(backgroundColor: Color = .white, foregroundColor: Color = .black, padding: CGFloat?, font: Font = .title, fontWeight: Font.Weight = .regular, minWidth: CGFloat? = nil, image: Image?) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.padding = padding
        self.font = font
        self.fontWeight = fontWeight
        self.minWidth = minWidth
        self.image = image
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    @State var isEnabled: Bool = true
    let styleInfo: PrimaryButtonStyleInfo
    
    func makeBody(configuration: Configuration) -> some View {
        let foregroundColor = isEnabled ? styleInfo.foregroundColor : .gray
        
        let label = configuration.label
            .background(styleInfo.backgroundColor)
            
        return HStack(spacing: 8) {
                styleInfo.image
                label
            }
            .foregroundStyle(foregroundColor)
            .padding(styleInfo.padding ?? 0)
            .font(styleInfo.font)
            .fontWeight(styleInfo.fontWeight)
            .frame(minWidth: styleInfo.minWidth ?? 0)
            .overlay {
                RoundedRectangle(cornerRadius: 2)
                    .stroke(styleInfo.foregroundColor, lineWidth: 2)
            }
            .scaleEffect(x: configuration.isPressed ? 0.9 : 1, y: configuration.isPressed ? 0.9 : 1, anchor: .center)
            .animation(.spring(response: 0.2, dampingFraction: 0.9, blendDuration: 0), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static func primary(_ styleInfo: PrimaryButtonStyleInfo) -> Self {
        Self(styleInfo: styleInfo)
    }
}
