local hg_comp = require("hangul/hangul_compose")
local config = require("tri_hangul_config")

local maps = {}
maps.key2onset = {}
maps.key2vowel = {}
maps.key2coda = {[" "] = ""}
for i, key in ipairs(config.keyboard) do
	maps.key2onset[key] = config.onset_map[i]
	maps.key2vowel[key] = config.vowel_map[i]
	maps.key2coda[key] = config.coda_map[i]
end

local function divide_string(s, n)
	local slices = {}
	local len = #s
	for i = 1, len, n do
		table.insert(slices, s:sub(i, i+n-1))
	end
	return slices
end

local function decode_syllable(code, maps)
	local onset = maps.key2onset[code:sub(1,1)] or ""
	local vowel = maps.key2vowel[code:sub(2,2)] or ""
	local coda = maps.key2coda[code:sub(3,3)] or ""

	return hg_comp.compose_syllable(onset, vowel, coda)
end

local function split_input(input)
	local codes = divide_string(input:sub(1, (#input // 3)*3), 3)
	codes.rem = nil
	if (#input % 3) ~= 0 then
		codes.rem = input:sub((#input // 3)*3 + 1, #input)
	end
	return codes
end

local P = {}

function P.init(env)
end

function P.fini(env)
end

function P.func(key, env)
	local context = env.engine.context
	local repr = key:repr()
	local back_seg = context.composition:back()
	local len = back_seg.length

	if repr == "space" and back_seg:has_tag("abc") then
		if len % 3 == 2 then
			context:push_input(" ")
			return 1 -- accepted
		end
	end

	return 2 -- noop
end

local T = {}

function T.init(env)
end

function T.fini(env)
end

function T.func(input, seg, env)
	local codes = split_input(input)
	local rem = codes.rem or ""

	local hangul = ""
	for _, code in ipairs(codes) do
		local success, ret = pcall(decode_syllable, code, maps)
		if not success then goto output end
		hangul = hangul..ret
	end

	if #rem == 1 then
		if maps.key2onset[rem] then
			hangul = hangul..maps.key2onset[rem]
		end
	elseif #rem == 2 then
		local success, ret = pcall(decode_syllable, rem.." ", maps)
		if success then
			hangul = hangul..ret
		end
	end

	::output::
	if hangul == "" then return end

	local cand = Candidate("hangul", seg.start, seg._end, hangul, " ")
	yield(cand)
end

return { tran=T, proc=P }
