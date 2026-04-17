local hg_comp = require("hangul_compose")
local config = require("tri_hangul_config")

local maps = {}
maps.key2onset = {}
maps.key2vowel = {}
maps.key2coda = {}
for i, key in ipairs(config.keyboard) do
	maps.key2onset[key] = config.onset_map[i]
	maps.key2vowel[key] = config.vowel_map[i]
	maps.key2coda[key] = config.coda_map[i]
end

local function decode_syllable(code, maps)
	local onset = maps.key2onset[code:sub(1,1)] or ""
	local vowel = maps.key2vowel[code:sub(2,2)] or ""
	local coda = maps.key2coda[code:sub(3,3)] or ""

	return hg_comp.compose_syllable(onset, vowel, coda)
end

local T = {}

function T.init(env)
end

function T.fini(env)
end

function T.func(input, seg, env)
	local code = input:sub(1,3)
	local rem = input:sub(4)

	local output = nil
	if #code == 1 then
		output = maps.key2onset[code]
	elseif #code == 2 then
		output = decode_syllable(code .. "X", maps)
	else
		output = decode_syllable(code, maps)
	end

	if not output then return end

	yield(Candidate("hangul", seg.start, seg._end, output, " "))
end

return { tran=T }
