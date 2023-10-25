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
            .font(.headline)
            .foregroundStyle(.launchScreenBackground)
            .padding(2.5)
            .background(labelColor)
            .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}


#Preview {
    VStack {
        FilterLabelView(filterLabel: "台北", labelColor: .teal)
        FilterLabelView(filterLabel: "三星", labelColor: .red)
        FilterLabelView(filterLabel: "綠星", labelColor: .green)

    }
}
