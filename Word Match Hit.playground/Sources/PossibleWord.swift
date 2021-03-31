import Foundation
import SpriteKit

public class PossibleWord {
    public var text: String = ""
    
    public typealias SetupMusic = () -> SKAction
    
    public var soundForMatch: SetupMusic?
    
    public init (){}
    
    public init (text: String){
        self.text = text
    }
    
    static func defaultSound (){}
}

