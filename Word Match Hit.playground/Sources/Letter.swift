import SpriteKit

public class Letter:SKShapeNode{
    public static var possibleLetters = " "
    public static var pointsForVowels = 1
    public static var pointsForConsonants = 20
    
    
    static var blockSize = CGFloat()
    
    public var word = Word()
    
    var label = SKLabelNode()
    var block = SKShapeNode()
    public var isMoving = true
    
    var row = Int()
    var col = Int()

    var onFloorRow = false
    var countMove = 0
    
    override init(){
        super.init()
    }
    
    init(rect: CGRect){
        super.init()
        block = SKShapeNode(rect: rect)
        self.addChild(block)
        label = SKLabelNode()
        label.fontSize = 20
        label.fontColor = SKColor.white
        label.fontName = "Helvetica-Bold"
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        label.position = CGPoint(x: (block.frame.midX), y: (block.frame.midY))
        block.addChild(label)
        randomLetter(possibles: Letter.possibleLetters)
    }
    
    func randomLetter(possibles: String){
        let characteres = Array(possibles)
        let randomIndex = Int(arc4random_uniform(UInt32(characteres.count)))
        self.label.text = String(characteres[randomIndex].description)
    }
    
    public func moveLeft(){
        if (self.position.x - Letter.blockSize < 0){
        }else{
            self.position.x -= Letter.blockSize
            self.col -= 1
        }
    }
    
    public func resetColor(){
        block.fillColor = SKColor.black
    }
    
    public func moveRight(){
        self.position.x += Letter.blockSize
        self.col += 1
    }
    
    public func moveDown(){
        self.position.y -= Letter.blockSize/4
    }
    
    public func colorRect(color: SKColor){
        block.fillColor = color
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
