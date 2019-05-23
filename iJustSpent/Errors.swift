//  Copyright © 2019 David New. All rights reserved.

import Foundation

//Error type to just send a description string
enum GenericError: Error {
    case description(text: String)
}
