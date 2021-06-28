//
//  NotesManager.swift
//  SimpleRem
//
//  Created by user200328 on 6/28/21.
//
import UIKit

enum FileErrors: Error {
    case badFileUrl
    case fileAlreadyExists
    case dirIsEmpty
    case unknownError
}

class NotesManager {
    
    static let shared = NotesManager()
    
    private let manager = FileManager.default
    
    private var documentsDirectoryURL: URL? {
        try? manager.url(for: .applicationSupportDirectory,
                         in: .allDomainsMask,
                         appropriateFor: nil,
                         create: false)
    }
    
    // MARK: - Creating Directory Logic
    func createDirectory(directoryName: String) throws {
        
        guard let directory = documentsDirectoryURL else {throw FileErrors.badFileUrl}
        let newDirectoryName = directory.appendingPathComponent(directoryName)
       
        do {
            try manager.createDirectory(at: newDirectoryName,
                                        withIntermediateDirectories: true,
                                        attributes: [:])
            print("Directory created successfully at \(documentsDirectoryURL!)")
        } catch {
            throw FileErrors.badFileUrl
        }
        
    }
    
    
    // MARK: - Note Creating Logic
    func createNote(inDirectory directoryName: String, noteName: String, noteTime: Date) throws {
        
        guard let directory = documentsDirectoryURL else {throw FileErrors.badFileUrl}
        
        let dirName = directory.appendingPathComponent(directoryName)
        let noteUrl = dirName.appendingPathComponent("\(noteName).json")
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let noteDate = df.string(from: noteTime)
        
        let dict: [String: String] = ["noteTitle" : noteName, "noteDate" : noteDate]
        let encoder = JSONEncoder()
        guard let noteData = try? encoder.encode(dict) else {return}
        if !noteExists(at: noteUrl.path) {
            manager.createFile(atPath: noteUrl.path,
                               contents: noteData,
                               attributes: [:])
        } else {
            throw FileErrors.fileAlreadyExists
        }
    }
    
    private func noteExists(at path: String) -> Bool {
        if manager.fileExists(atPath: path) {
            return true
        } else {
            return false
        }
    }
    // MARK: - All Directories Logic
    func getAllDirectories() throws -> [String] {
        guard let directory = documentsDirectoryURL else {throw FileErrors.badFileUrl}
        
        do {
            let directories = try manager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
            let filteredDirs = directories.map{ $0.path.components(separatedBy: "/").last}
            return filteredDirs.compactMap{$0}
        } catch {
            throw FileErrors.badFileUrl
        }
    }
    
    // MARK: - All Notes Logic
    func getAllNotesForDirectory(dir: String) throws -> [NoteModel] {
        guard var directory = documentsDirectoryURL else {throw FileErrors.badFileUrl}
        directory.appendPathComponent(dir)
        
        var notes = [NoteModel]()
        
        let directories = try manager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
        
        let fetchedNotes = directories.filter { $0.pathExtension == "json" }
        
        for note in fetchedNotes {
            do {
                let data = try Data(contentsOf: note)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(NoteModel.self, from: data)
                notes.append(jsonData)
            } catch {
                throw FileErrors.unknownError
            }
        }
                
        return notes
    }
    
    // MARK: - Note Updating Logic
    func updateNote(inDirectory directoryName: String, noteName: String, noteTime: Date) throws {
        guard let directory = documentsDirectoryURL else {throw FileErrors.badFileUrl}
        
        let dirName = directory.appendingPathComponent(directoryName)
        let noteUrl = dirName.appendingPathComponent("\(noteName).json")
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let noteDate = df.string(from: noteTime)
        
        let dict: [String: String] = ["noteTitle" : noteName, "noteDate" : noteDate]
        let encoder = JSONEncoder()
        guard let noteData = try? encoder.encode(dict) else {return}
        
        manager.createFile(atPath: noteUrl.path,
                            contents: noteData,
                            attributes: [:])
        
    }
    
    // MARK: - Note Deleting Logic
    func deleteNote(dir: String, noteName: String) throws {
        
        guard let directory = documentsDirectoryURL else {throw FileErrors.badFileUrl}
        let currentDir = directory.appendingPathComponent(dir)
        let noteUrl = currentDir.appendingPathComponent("\(noteName).json")
        
        do {
            try manager.removeItem(at: noteUrl)
        } catch {
            throw FileErrors.dirIsEmpty
        }
            
    }
    
}
