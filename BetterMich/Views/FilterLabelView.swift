//
//  FilterLabelView.swift
//  BetterMich
//
//  Created by 吳求元 on 2023/10/25.
//

import SwiftUI

struct FilterLabelView: View {
    
    var filterLabel: String
    var labelColor: Color
    
    var body: some View {
        Text(filterLabel)
            .foregroundStyle(.white)
            .padding(2.5)
            .background(labelColor)
            .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}


#Preview {
    FilterLabelView(filterLabel: "台北", labelColor: .teal)
}
