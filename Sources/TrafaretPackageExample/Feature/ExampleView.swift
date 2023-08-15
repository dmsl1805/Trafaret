import SwiftUI
import Trafaret

struct ExampleView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .resizable()
                .frame(width: 44, height: 44)
                .foregroundColor(.accentColor)
            
            Text("Hello, world!")
                .font(.system(size: 48))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color.white
        )
    }
}

@available(iOS 16.0, *)
public struct ExampleViewPreview: PreviewProvider, TrafaretSnapshotProvider {
        
    public static var compareConfig: CompareConfig {
        .sideBySide(gridsOnEach: 56)
    }
    
    public static let previewContainer = PreviewContainer.device(.iPhone12, scale: 3)
    
    public static let path = Package.trafaretFilePath()
    
    public static let testConfig = Package.testConfig()

    public static var body: some View {
        ExampleView()
    }
}
