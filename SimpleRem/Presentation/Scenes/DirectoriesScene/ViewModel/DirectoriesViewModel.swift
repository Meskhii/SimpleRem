//
//  MainViewModel.swift
//  SimpleRem
//
//  Created by user200328 on 6/28/21.
//

import Foundation

protocol DirectoriesViewModelProtocol: AnyObject {
    func fetchDirectories() throws -> [String]
    func fetchNotes(for category: String) throws -> [NoteModel]
    func createDirectory(dirName: String) throws
    func createNote(inDirectory: String, noteName: String, noteTime: Date) throws
}

final class DirectoriesViewModel: DirectoriesViewModelProtocol {
    
    func fetchDirectories() throws -> [String] {
        do {
            let dirs = try NotesManager.shared.getAllDirectories()
            return dirs
        } catch {
            throw FileErrors.badFileUrl
        }
    }
    
    func createDirectory(dirName: String) throws {
        do {
            try NotesManager.shared.createDirectory(directoryName: dirName)
        } catch FileErrors.badFileUrl {
            throw FileErrors.badFileUrl
        } catch {
            throw FileErrors.unknownError
        }
    }
    
    func createNote(inDirectory: String, noteName: String, noteTime: Date) throws {
        do {
            try NotesManager.shared.createNote(inDirectory: inDirectory, noteName: noteName, noteTime: noteTime)
        } catch FileErrors.fileAlreadyExists {
            throw FileErrors.fileAlreadyExists
        } catch {
            throw  FileErrors.unknownError
        }
    }
    
    func fetchNotes(for category: String) throws -> [NoteModel] {
        do {
            let dirs = try NotesManager.shared.getAllNotesForDirectory(dir: category)
            return dirs
        } catch {
            throw FileErrors.badFileUrl
        }
    }
}

