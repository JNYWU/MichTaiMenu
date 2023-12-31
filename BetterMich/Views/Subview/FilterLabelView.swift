import SwiftUI

struct FilterLabelView: View {
    
    var filterLabel: String
    var labelColor: Color
    
    var body: some View {
        Text(filterLabel)
            .font(.headline)
            .foregroundStyle(.launchScreenBackground)
            .padding(3)
            .background(labelColor)
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}


#Preview {
    VStack {
        FilterLabelView(filterLabel: "台北", labelColor: .teal)
        FilterLabelView(filterLabel: "三星", labelColor: .red)
        FilterLabelView(filterLabel: "綠星", labelColor: .green)

    }
}
