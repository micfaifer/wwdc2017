import SpriteKit

public class TextInf: SKShapeNode{
    var label = SKLabelNode()
    var rect = SKShapeNode()
    
    override init(){
        super.init()
    }
    
    init(rect: CGRect){
        super.init()
        self.rect = SKShapeNode(rect: rect)
        
        self.addChild(self.rect)
        
        self.label.fontSize = 25
        self.label.fontColor = SKColor.white
        self.label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        self.label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.label.fontName = "Helvetica-Bold"
        
        self.label.position =  CGPoint(x: (self.rect.frame.midX), y: (self.rect.frame.midY))
        self.rect.addChild(self.label)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
