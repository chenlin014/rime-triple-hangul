local config = {}

config.keyboard = {
	"q", "w", "e", "r", "t", "y", "u", "i", "o", "p",
	"a", "s", "d", "f", "g", "h", "j", "k", "l", ";",
	"z", "x", "c", "v", "b", "n", "m", ",", ".", "/"
}

config.onset_map = {
	"ㅃ", "ㅉ", "ㄸ", "ㄲ", "ㅆ", nil,  nil,  nil,  nil,  nil,
	"ㅂ", "ㅈ", "ㄷ", "ㄱ", "ㅅ", "ㄹ", "ㅇ", "ㄴ", "ㅁ", nil,
	"ㅍ", "ㅊ", "ㅌ", "ㅋ", nil,  nil,  "ㅎ"
}

config.vowel_map = {
	nil,  "ㅠ", "ㅛ", "ㅚ", nil,  nil, "ㅕ", "ㅑ", "ㅒ", "ㅖ",
	"ㅡ", "ㅜ", "ㅗ", "ㅣ", "ㅢ", nil, "ㅓ", "ㅏ", "ㅐ", "ㅔ",
	nil,  nil,  nil,  "ㅟ", nil,  nil, "ㅝ", "ㅘ", "ㅙ", "ㅞ"
}

config.coda_map = {
	"ㅃ", "ㅉ", "ㄸ", "ㄲ", "ㅆ", "ㄳ", "ㅀ", "ㄶ", "ㄼ", "ㄿ",
	"ㅂ", "ㅈ", "ㄷ", "ㄱ", "ㅅ", "ㅄ", "ㅇ", "ㄴ", "ㅁ", "ㄹ",
	"ㅍ", "ㅊ", "ㅌ", "ㅋ", "ㄺ", "ㄽ", "ㅎ", "ㄵ", "ㄻ", "ㄾ"
}

config.key2sym = {
	["grave"] = "`",
	["asciitilde"] = "~",
	["exclam"] = "!",
	["at"] = "@",
	["numbersign"] = "#",
	["dollar"] = "$",
	["percent"] = "%",
	["asciicircum"] = "^",
	["ampersand"] = "&",
	["asterisk"] = "*",
	["parenleft"] = "(",
	["parenright"] = ")",
	["minus"] = "-",
	["underscore"] = "_",
	["plus"] = "+",
	["equal"] = "=",
	["bracketleft"] = "[",
	["bracketright"] = "]",
	["braceleft"] = "{",
	["braceright"] = "}",
	["backslash"] = "\\",
	["bar"] = "|",
	["colon"] = ":",
	["semicolon"] = ";",
	["quotedbl"] = "\"",
	["apostrophe"] = "'",
	["comma"] = ",",
	["period"] = ".",
	["less"] = "<",
	["greater"] = ">",
	["slash"] = "/",
	["question"] = "?",
}

return config
