-- Derived from https://github.com/jonghwanhyeon/hangul-jamo

local M = {}

M.base_of_syllables = 44032

M.onset_count = 19
M.vowel_count = 21
M.coda_count = 28

M.syllable_per_onset = M.vowel_count * M.coda_count
M.syllable_count = M.onset_count * M.syllable_per_onset

M.onsets = {'ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ', 'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'}

M.vowels = {'ㅏ', 'ㅐ', 'ㅑ', 'ㅒ', 'ㅓ', 'ㅔ', 'ㅕ', 'ㅖ', 'ㅗ', 'ㅘ', 'ㅙ', 'ㅚ', 'ㅛ', 'ㅜ', 'ㅝ', 'ㅞ', 'ㅟ', 'ㅠ', 'ㅡ', 'ㅢ', 'ㅣ'}

M.codas = {'', 'ㄱ', 'ㄲ', 'ㄳ', 'ㄴ', 'ㄵ', 'ㄶ', 'ㄷ', 'ㄹ', 'ㄺ', 'ㄻ', 'ㄼ', 'ㄽ', 'ㄾ', 'ㄿ', 'ㅀ', 'ㅁ', 'ㅂ', 'ㅄ', 'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'}

M.onset_index = {}
for i, onset in ipairs(M.onsets) do
	M.onset_index[onset] = i - 1
end

M.vowel_index = {}
for i, vowel in ipairs(M.vowels) do
	M.vowel_index[vowel] = i - 1
end

M.coda_index = {}
for i, coda in ipairs(M.codas) do
	M.coda_index[coda] = i - 1
end

return M
