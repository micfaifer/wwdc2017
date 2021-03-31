import SpriteKit

public class NextLetterArea: SKShapeNode{
    var blockSize = CGFloat()
    
    var rect = SKShapeNode()
    var letter = Letter()
    
    override init(){
        super.init()
    }
    
    init(rect: CGRect){
        super.init()
        self.rect = SKShapeNode(rect: rect)
        self.addChild(self.rect)
        
        self.rect.position.y += 10
        self.rect.position.x += self.rect.frame.width + 30
        letter = Letter(rect: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: blockSize, height: blockSize)))
        
        letter.name = "letter"
        self.rect.addChild(self.letter)
        
        letter.position.x = self.rect.frame.width/2 - (blockSize/2)*1.5
        letter.position.y = self.rect.frame.height/2 - (blockSize/2)*1.5
        letter.setScale(1.5)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
