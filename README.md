# SafeSpace 🛡️👶

**SafeSpace** is an intuitive, interactive iOS application designed to help parents and guardians identify and mitigate potential household dangers for children in real-time. Built specifically for the **Apple Swift Student Challenge**, SafeSpace leverages the power of on-device Machine Learning and Augmented Reality to turn an iPhone into a smart safety scanner.

## 🌟 Features

- **Real-Time Hazard Detection:** Simply point your camera around your home. SafeSpace's custom CoreML model instantly processes the live feed to identify hazards.
- **Dynamic AR Overlays:** When a dangerous item is detected, SafeSpace overlays a smooth, pulsing AR bounding box directly onto the physical object, making the danger immediately obvious.
- **Smart Scanning System:** Avoids jarring false positives with a built-in 1.2-second confident scanning ring before alerting the user.
- **Actionable Safety Tips:** Displays clear, non-alarming, and actionable safety advice on a neat "Danger Card" corresponding to the specific hazard detected.
- **History Tracking:** Automatically logs the last 20 detected hazards along with their timestamps and confidence levels so you can review potential blind spots in your home later.
- **Privacy First, On-Device Processing:** All computer vision and machine learning inferences happen locally on the device via the Vision framework—no camera feeds are ever sent to the cloud.

## 🎯 What We Detect

SafeSpace's model is trained to recognize three primary high-risk categories in the home:

1. ✂️ **Scissors & Knives** (Sharp objects)
2. 🔌 **Electrical Outlets & Cables** (Exposed sockets and wiring)
3. 🫧 **Cleaning Products** (Harmful chemicals within reach)

## 🛠️ Technology Stack

SafeSpace is built using modern Apple frameworks and fully embraces declarative UI and spatial computing concepts:

- **SwiftUI:** Entirely built with SwiftUI for a reactive, state-driven, and highly animated interface (including custom bottom sheets, onboarding flows, and haptic feedback integrations).
- **CoreML & CreateML:** Uses a custom trained Image Classification model natively integrated to run optimally on Apple Silicon.
- **ARKit & SceneKit:** Uses `ARWorldTrackingConfiguration` and `ARSCNView` wrapped in a `UIViewRepresentable` to project safety warnings spatially.
- **Vision Framework:** Handles the heavy lifting of extracting and processing `CVPixelBuffer` frames from the ARKit camera feed efficiently on background queues.
- **Combine:** Powers the reactive `ARViewModel` pipeline to keep the view state perfectly synchronized with hardware sensors.

## 🚀 Getting Started

### Prerequisites

- Xcode 15.0 or later
- iOS 17.0 or later
- An iPhone or iPad with an A9 chip or later (Requires physical device for ARKit camera tracking; the iOS Simulator does not support live ARKit camera feeds).

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/tade-dev/FoodSenseAR.git
   ```
2. Open `FoodSenseAR.xcodeproj` in Xcode.
3. Select your physical iOS device as the run destination.
4. Ensure your Apple Developer Signing Identity is selected in the **Signing & Capabilities** tab.
5. Build and Run (`Cmd + R`).

## 💡 How It Works

1. **Onboarding:** First-time users are greeted with a beautiful, paginated onboarding flow explaining house scanning.
2. **Scanning:** As you pan the camera, the `ARViewContainer` passes frames every 0.5s to the `DetectionService`.
3. **Validating:** If the CoreML model hits a confidence threshold of >90%, a visual HUD ring begins tracking the object.
4. **Alerting:** If the object remains in frame for an uninterrupted 1.2 seconds, the AR engine drops a frosted-glass Danger Card providing detailed safety instructions, and logs it to History.

---

_Created with ❤️ for the Apple Swift Student Challenge._
