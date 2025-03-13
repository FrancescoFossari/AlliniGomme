import SwiftUI
import Foundation

// 📖 Legge il file TXT e crea un dizionario targa -> ubicazione, misura e quantità
func loadTXT(from filename: String) -> [String: (String, String, String)] {
    var data: [String: (String, String, String)] = [:]

    if let fileURL = Bundle.main.url(forResource: filename, withExtension: "txt") {
        do {
            let content = try String(contentsOf: fileURL, encoding: .utf8)
            let lines = content.components(separatedBy: "\n").filter { !$0.isEmpty }

            for line in lines {
                let fields = line.components(separatedBy: ",")
                if fields.count >= 4 { // Targa, Ubicazione, Misura, Quantità
                    let targa = fields[0].uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
                    let ubicazione = fields[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    let misura = fields[2].trimmingCharacters(in: .whitespacesAndNewlines)
                    let quantita = fields[3].trimmingCharacters(in: .whitespacesAndNewlines)
                    data[targa] = (ubicazione, misura, quantita)
                }
            }
        } catch {
            print("❌ Errore nella lettura del TXT: \(error)")
        }
    } else {
        print("❌ Il file \(filename).txt NON è stato trovato nel Bundle!")
    }
    
    return data
}

// 🏠 Interfaccia principale
struct ContentView: View {
    @State private var targa = ""
    @State private var message: String? = nil
    @State private var data: [String: (String, String, String)] = [:]

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.yellow.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 25) {
                Image("logo2")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 220)
                    .padding(.top, 20)
                    .shadow(radius: 5)

                Text("Gestione Gomme Cambio Stagione")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(Color.yellow)
                    .shadow(color: .black.opacity(0.2), radius: 3, x: 2, y: 2)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    
                TextField("Inserisci la targa", text: $targa)
                    .font(.title2)
                    .foregroundColor(.black)
                    .autocapitalization(.allCharacters)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white).shadow(radius: 3))
                    .padding(.horizontal, 20)
                    .multilineTextAlignment(.center)

                Button(action: {
                    let formattedTarga = targa.uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) // Chiude la tastiera
                    if let (ubicazione, misura, quantita) = data[formattedTarga] {
                        message = "\n📍 Ubicazione: \(ubicazione)\n🔹 Misura: \(misura)\n📦 Quantità: \(quantita)\n"
                    } else {
                        message = "❌ Targa non trovata ❌"
                    }
                }) {
                    Text("Cerca")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(12)
                        .shadow(radius: 3)
                }
                .padding(.horizontal, 20)
                
                if let message = message {
                    ScrollView { // Aggiungiamo uno ScrollView per evitare il taglio del testo
                        Text(message)
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                            //.padding()
                            .frame(maxWidth: .infinity, minHeight: 100) // Evita che venga tagliato
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(12)
                            .shadow(radius: 3)
                            .padding(.horizontal, 20)
                            .multilineTextAlignment(.leading) // Garantisce allineamento corretto
                            .lineLimit(nil) // Permette testo su più righe
                            .fixedSize(horizontal: false, vertical: true) // Evita che venga compresso
                    }
                    .frame(maxHeight: 250) // Limita l'altezza massima per evitare problemi di layout
                }

                
                Text("Software Made by Francesco Fossari")
                    .font(.footnote)
                    .foregroundColor(.blue)
                    .padding(.bottom, 10)
            }
            .padding()
        }
        .onAppear {
            data = loadTXT(from: "deposito_pulito")
        }
    }
}

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

