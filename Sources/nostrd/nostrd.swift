@main
public struct nostrd {
    public private(set) var text = "Hello, World!"

    public static func main() {
        print(nostrd().text)
    }
}
