import SwiftUI

extension View {
    @ViewBuilder
    func glassChip() -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect(.regular)
        } else {
            self
        }
    }
}
