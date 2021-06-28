//
//  NotesViewModel.swift
//  SimpleRem
//
//  Created by user200328 on 6/28/21.
//

import Foundation

protocol NotesViewModelProtocol: AnyObject {
    func fetchNotes(for category: String) throws -> [NoteModel]
}

final class NotesViewModel: NotesViewModelProtocol {
    func fetchNotes(for category: String) throws -> [NoteModel] {
        do {
            let dirs = try NotesManager.shared.getAllNotesForDirectory(dir: category)
            return dirs
        } catch {
            throw FileErrors.badFileUrl
        }
    }
}

