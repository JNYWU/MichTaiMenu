import SwiftUI

struct FilterLabelView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var filterLabel: String
    var labelColor: Color
    var isFiltered: Bool = true
    
    var body: some View {
        Text(filterLabel)
            .font(.headline)
            .padding(3)
            .background(labelColor)
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}


#Preview {
    VStack {
        FilterLabelView(filterLabel: "台北", labelColor: .teal, isFiltered: true)
        FilterLabelView(filterLabel: "三星", labelColor: .red, isFiltered: true)
        FilterLabelView(filterLabel: "綠星", labelColor: .green, isFiltered: true)
        FilterLabelView(filterLabel: "三星", labelColor: Color(.systemGray5), isFiltered: false)
    }
}
