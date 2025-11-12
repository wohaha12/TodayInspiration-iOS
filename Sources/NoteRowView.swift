import SwiftUI

struct NoteRowView: View {
    @ObservedObject var note: Note

    var body: some View {
        HStack {
            if let img = note.uiImage {
                Image(uiImage: img)
                    .resizable()
                    .frame(width: 56, height: 56)
                    .cornerRadius(8)
            }
            VStack(alignment: .leading) {
                Text(note.title ?? "（无标题）")
                    .font(.headline)
                Text(note.body ?? "")
                    .font(.subheadline)
                    .lineLimit(2)
                    .foregroundColor(.secondary)
                HStack {
                    ForEach(note.tags, id: \.self) { tag in
                        Text(tag).font(.caption).padding(4).background(Color.secondary.opacity(0.12)).cornerRadius(6)
                    }
                }
            }
        }.padding(.vertical, 6)
    }
}
