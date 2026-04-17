-- Copied from https://github.com/jonghwanhyeon/hangul-jamo

local hangul = require("unicode_hangul")

local M = {}

function M.decompose_syllable(char)
	local syllable_index = utf8.codepoint(char) - hangul.base_of_syllables

	local onset_index = syllable_index // hangul.syllable_per_onset + 1
	local vowel_index = (syllable_index % hangul.syllable_per_onset) // hangul.coda_count + 1
	local coda_index = syllable_index % hangul.coda_count + 1

	local onset = hangul.onsets[onset_index]
	local vowel = hangul.vowels[vowel_index]
	local coda = hangul.codas[coda_index]

	if not (onset and vowel and coda) then
		error("Invalid syllable: " .. char)
	end

	return {onset=onset, vowel=vowel, coda=coda}
end

function M.compose_syllable(onset, vowel, coda)
	local onset_ind = hangul.onset_index[onset]
	local vowel_ind = hangul.vowel_index[vowel]
	local coda_ind = hangul.coda_index[coda]

	local onset_vowel_ind = (onset_ind * hangul.syllable_per_onset) + (vowel_ind * hangul.coda_count)
	local syllable_index = onset_vowel_ind + coda_ind

	return utf8.char(hangul.base_of_syllables + syllable_index)
end

return M
