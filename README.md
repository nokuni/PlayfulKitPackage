# PlayfulKit

## NODES

### **PKMapNode**:
*Create a grid map of sprite nodes.*

### **PKProgressBarNode**:
*Create a progress bar with or without images.*

### **PKScribeNode**
*Create a writing text.*

```swift
// The setup includes the configuration of the scene size. It is needed to display correctly the content of the node.
setup()

let content = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua"
let padding = EdgeInsets(top: 60, leading: 30, bottom: 0, trailing: 30)

let parameter = TextManager.Paramater(content: content, padding: padding)

let typewriterNode = PKTypewriterNode(container: self, parameter: parameter)

addChild(typewriterNode)
```

# UTILITIES

##PKHaptics: 
Manage haptics.

##PKLanguage: 
Manage language.

##PKSound: 
Manage sounds.

##PKMatrix: 
Create nodes list or collection.

##PKSceneViewManager: 
Manage the navigation between scenes.

##PKText: 
WIP.

##PKAnimation: 
WIP.

##PKTimer: 
WIP.


