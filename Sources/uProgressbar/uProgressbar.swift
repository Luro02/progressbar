/* based of: https://github.com/tripped/progressbar
 */

open class ProgressBar {
    var progress: Double
    var width: UInt
    let colors = [
        "fill": [
            005, 099, 105, 111, 117, 123, 086, 080, 074,
            068, 062, 062, 068, 074, 080, 086, 123, 117,
            111, 105, 099, 005, 005, 099, 105, 111, 117,
            123, 086, 080, 074, 068, 062, 062, 068, 074,
            080, 086, 123, 117, 111, 105, 099, 005, 005,
            099, 105, 111, 117, 123, 086, 080, 074, 068,
            062, 062, 068, 074, 080, 086, 123, 117, 111,
            105, 099, 005, 005, 099, 105, 111, 117, 123,
            086, 080, 074, 068, 062, 062, 068, 074, 080,
            086, 123, 117, 111, 105, 099, 005, 005, 099,
            105, 111, 117, 123, 086, 080, 074, 068, 062,
            062, 068, 074, 080, 086, 123, 117, 111, 105,
            099, 005, 005, 099, 105, 111, 117, 123, 086,
            080, 074, 068, 062, 062, 068, 074, 080, 086,
            123, 117, 111, 105, 099, 005
        ],
        "border": [
            0
        ],
        "text": [
            235
        ]
    ]
    init(width: UInt) {
        self.width = width
        self.progress = 0.0
        self.render()
    }
    func render() {
        let fullwidth = Double(self.width - 2) * self.progress
        let blocks = Int(fullwidth)
        let remainder = fullwidth - Double(blocks)
        self.setfg(colortype: "border")
        print( // upper border
            String(
                repeating: "\u{2581}",
                count: Int(self.width)
            ),
            terminator: "\n"
        )
        print("\u{2588}", terminator: "") // left edge
        // Content:
        self.setfg(colortype: "fill")
        print(
            String(
                repeating: "\u{2588}",
                count: Int(blocks)
            ),
            terminator: ""
        )
        if remainder > 0 {
            print(
                self.stringIndex(
                    str: " ▏▎▍▌▋▊▉█",
                    index: Int(remainder * 8)
                ),
                terminator: ""
            )
        }
        var spaceSize = Int((Int(self.width) - 3 - blocks))
        if spaceSize < 0 {
            spaceSize = 0 // precaution against the case that this value gets negative!
        }
        print(
            String(
                repeating: " ",
                count: spaceSize
            ),
            terminator: ""
        ) // progress
        self.setfg(colortype: "border")
        print("\u{2588}", terminator: "\n") // right edge
        print(
            String(
                repeating: "\u{2594}",
                count: Int(self.width)
            ),
            terminator: "\n"
        ) // lower border
        // Text inside:
        let percent = " \(Int(self.progress * 100))%"
        if blocks >= percent.count {
            print("\u{001b}7\u{001b}[2G\u{001b}[2A", terminator: "")
            self.setbg(colortype: "fill")
            self.setfg(colortype: "text")
            print(percent, terminator: "")
            print("\u{001b}8", terminator: "")
        }
        self.resetfg()
        self.resetbg()
    }
    func progressiveColor(_ colortype: String) -> UInt {
        let colorset = self.colors[colortype]!
        let length: Double = Double(colorset.count)
        var index = Int(self.ceil((self.progress * length)) - 1)
        // index can't be negative like in Python, this is a workaround
        // so that -1 works like in Python and accesses the last element
        // of the array/list.
        if index < 0 {
            index = Int(length + Double(index + 1)) - 1
        }
        return UInt(colorset[index])
    }
    func setfg(colortype: String) {
        let cret = self.progressiveColor(colortype)
        if cret != 0 {
            self.changeColor(color: cret, num: 0)
        } else {
            self.resetfg()
        }
    }
    func setbg(colortype: String) {
        let cret = self.progressiveColor(colortype)
        if cret != 0 {
            self.changeColor(color: cret, num: 1)
        } else {
            self.resetbg()
        }
    }
    func resetfg() {
        print("\u{001b}[39m", terminator: "")
    }
    func resetbg(){
        print("\u{001b}[49m", terminator: "")
    }
    func changeColor(color: UInt, num: UInt) {
        switch num {
        case 0:
            print("\u{001b}[38;5;\(color)m", terminator: "")
        case 1:
            print("")
            print("\u{001b}[48;5;\(color)m", terminator: "")
        default:
            print("\u{001b}[38;5;\(color)m", terminator: "")
        }
    }
    func update(amount: Double) {
        let progress = self.progress + amount
        self.progress = self.min(self.max(progress, 0.0), 1.0)

        // Restore cursor position and redraw:
        print("\u{1b}[?25l", terminator: "")
        print("\u{1b}[3F", terminator: "")
        self.render()
        print("\u{1b}[?25h", terminator: "")
    }
    func max(_ numbers: Double...) -> Double {
        /* returns biggest number in the function args
         */
        var bNum = numbers[0]
        for number in numbers where number > bNum {
            bNum = number
        }
        return bNum
    }
    func min(_ numbers: Double...) -> Double {
        /* returns smallest number in the function args
         */
        var sNum = numbers[0]
        for number in numbers where number < sNum {
            sNum = number
        }
        return sNum
    }
    func ceil(_ num: Double) -> Int {
        /* ceil function:
         * adapted from here: https://stackoverflow.com/a/8377539
         */
        let inum: Int = Int(num)
        if num == Double(inum) {
            return inum
        }
        return Int(inum + 1)
    }
    func stringIndex(str: String, index: Int) -> String {
        /* Workaround because String indicies aren't working!
        */
        var array: [String] = []
        for char in str {
            array.append(String(char))
        }
        return array[index]
    }
}
