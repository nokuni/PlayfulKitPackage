# PlayfulKit

## NODES

### **PKMapNode**:
*Create a grid map of sprite nodes.*
```swift
// The setup includes the configuration of the scene size. It is needed to display the node correctly.
setup()

let squareSize = CGSize(width: 30, height: 30)
let matrix = Matrix(row: 10, column: 10)
let origin: CGPoint = cornerPosition(corner: .topLeft, 
                                     node: self, 
                                     padding: EdgeInsets(top: 100, leading: 60, bottom: 0, trailing: 0))

let map = PKMapNode(squareSize: squareSize, matrix: matrix, origin: origin)

addChild(map)
```

### **PKProgressBarNode**:
*Create a progress bar with or without images.*
```swift
// The setup includes the configuration of the scene size. It is needed to display the node correctly.

setup()

let configuration = PKProgressBarNode.ShapeConfiguration(amount: 0.4, 
                                                         size: CGSize(width: 200, height: 20),
                                                         color: .green,
                                                         underColor: .gray,
                                                         cornerRadius: 15)

let progressBar = PKProgressBarNode(configuration: configuration)
progressBar.position = .center

addChild(progressBar)
```

### **PKScribeNode**
*Create a writing text.*

```swift
// The setup includes the configuration of the scene size. It is needed to display the content of the node correctly.

setup()

let content = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua"
let padding = EdgeInsets(top: 60, leading: 30, bottom: 0, trailing: 30)

let parameter = TextManager.Paramater(content: content, padding: padding)

let typewriterNode = PKTypewriterNode(container: self, parameter: parameter)

addChild(typewriterNode)
```
### **PKTimerNode**
*Create a timer node.*
```swift
setup()
let countdown: Int = 5

let label = SKLabelNode(text: "\(countdown)")
label.position = .center

addChild(label)

let configuration = PKTimerNode.TimerConfiguration(countdown: countdown)

let timer = PKTimerNode(label: label, configuration: configuration)

label.addChild(timer)

timer.start()
```


