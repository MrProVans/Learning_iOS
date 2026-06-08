import SwiftUI
import UIKit

struct AppIconImageView: View {
    let assetName: String?
    let fallbackSystemName: String
    let size: CGFloat

    var body: some View {
        if let assetName, UIImage(named: assetName) != nil {
            Image(assetName)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        } else {
            Image(systemName: fallbackSystemName)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .foregroundStyle(AppTheme.accentGold)
        }
    }
}
