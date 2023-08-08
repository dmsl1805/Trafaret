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
                .offset(y: 0.6)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        .background(
            Color.white
        )
    }
}

public struct ExampleViewPreview: PreviewProvider, TrafaretSnapshotProvider {
    public static var compareConfig: CompareConfig {
        .trafaret(opacity: 0.5)
    }
    
    public static let previewContainer = PreviewContainer.device(.iPhone12)
    
    public static let path = FilePath.defaultFile()
    
    public static let testConfig = TestConfig()

    public static var body: some View {
        ExampleView()
    }
}
