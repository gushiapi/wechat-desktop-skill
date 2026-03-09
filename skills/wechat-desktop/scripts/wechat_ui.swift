import Cocoa
import ApplicationServices

enum Command: String {
    case clickRelative = "click-relative"
    case scrollRelative = "scroll-relative"
}

func fail(_ message: String) -> Never {
    fputs("\(message)\n", stderr)
    exit(1)
}

func doubleArg(_ raw: String, _ name: String) -> Double {
    guard let value = Double(raw) else { fail("Invalid \(name): \(raw)") }
    return value
}

func intArg(_ raw: String, _ name: String) -> Int32 {
    guard let value = Int32(raw) else { fail("Invalid \(name): \(raw)") }
    return value
}

func absolutePoint(x: Double, y: Double, width: Double, height: Double, relX: Double, relY: Double) -> CGPoint {
    CGPoint(x: x + width * relX, y: y + height * relY)
}

func moveMouse(to point: CGPoint) {
    CGEvent(mouseEventSource: nil, mouseType: .mouseMoved, mouseCursorPosition: point, mouseButton: .left)?.post(tap: .cghidEventTap)
}

func click(at point: CGPoint) {
    CGEvent(mouseEventSource: nil, mouseType: .leftMouseDown, mouseCursorPosition: point, mouseButton: .left)?.post(tap: .cghidEventTap)
    usleep(40000)
    CGEvent(mouseEventSource: nil, mouseType: .leftMouseUp, mouseCursorPosition: point, mouseButton: .left)?.post(tap: .cghidEventTap)
}

func scroll(lines: Int32) {
    CGEvent(scrollWheelEvent2Source: nil, units: .line, wheelCount: 1, wheel1: lines, wheel2: 0, wheel3: 0)?.post(tap: .cghidEventTap)
}

let args = CommandLine.arguments
guard args.count >= 8 else {
    fail("Usage: wechat_ui.swift <click-relative|scroll-relative> x y width height relX relY [lines]")
}

guard let command = Command(rawValue: args[1]) else {
    fail("Unsupported command: \(args[1])")
}

let x = doubleArg(args[2], "x")
let y = doubleArg(args[3], "y")
let width = doubleArg(args[4], "width")
let height = doubleArg(args[5], "height")
let relX = doubleArg(args[6], "relX")
let relY = doubleArg(args[7], "relY")
let point = absolutePoint(x: x, y: y, width: width, height: height, relX: relX, relY: relY)

moveMouse(to: point)
usleep(80000)

switch command {
case .clickRelative:
    click(at: point)
case .scrollRelative:
    guard args.count >= 9 else { fail("scroll-relative requires lines") }
    click(at: point)
    usleep(120000)
    scroll(lines: intArg(args[8], "lines"))
}
