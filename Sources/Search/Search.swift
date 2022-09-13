import ArgumentParser
import Foundation

@main
struct Search: ParsableCommand {
	
	static let configuration = CommandConfiguration(abstract: "Search for a piece of text in a file")
	
	@Argument(help: "The file to search for text from.")
	var file: String

	@Argument(help: "The phrase to search.")
	var text: String
	
	@Flag(name: .shortAndLong, help: "Ignore case.")
	var ignoreCase = false
	
	@Flag(name: .shortAndLong, help: "Show line numbers.")
	var lineNumbers = false
	
	func validate() throws {
		if (try URL(fileURLWithPath: file).resourceValues(forKeys: [.isDirectoryKey])).isDirectory! {
			throw ValidationError("\(file): Is a directory.")
		}
		if !FileManager().fileExists(atPath: file) {
			throw ValidationError("\(file): File cannot be found.")
		}
		if !FileManager().isReadableFile(atPath: file) {
			throw ValidationError("\(file): Cannot read file.")
		}
	}
	
	mutating func run() throws {
		var comparableFileContents = try String(contentsOf: URL(fileURLWithPath: file))
		let printableFileLines = comparableFileContents.components(separatedBy: "\n")
		
		if ignoreCase {
			comparableFileContents = comparableFileContents.lowercased()
			text = text.lowercased()
		}
		
		if !comparableFileContents.contains(text) {
			print("\"\(text)\" cannot be found.")
			return
		}
		
		let comparablefileLines = comparableFileContents.components(separatedBy: "\n")
		for (index, line) in comparablefileLines.enumerated() {
			var coloredLine = printableFileLines[index]
			
			if line.contains(text) {
				if ignoreCase {
					coloredLine = coloredLine
						.replacingOccurrences(of: text, with: "\u{001B}[1;31m\(text)\u{001B}[0;0m")
						.replacingOccurrences(of: text.uppercased(), with: "\u{001B}[1;31m\(text.uppercased())\u{001B}[0;0m")
						.replacingOccurrences(of: text.lowercased(), with: "\u{001B}[1;31m\(text.lowercased())\u{001B}[0;0m")
						.replacingOccurrences(of: text.capitalized, with: "\u{001B}[1;31m\(text.capitalized)\u{001B}[0;0m")
					
				} else {
					coloredLine = coloredLine
						.replacingOccurrences(of: text, with: "\u{001B}[1;31m\(text)\u{001B}[0;0m")
					
				}
				
				print(lineNumbers ? String((index + 1)) + ":" + coloredLine : coloredLine)
			}
		}
	}
}
