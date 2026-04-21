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
	local schema_cfg = env.engine.schema.config
	local key_repr = key:repr()

	local commit_text = context:get_commit_text()
	local input = context.input or ""
	local back_seg = context.composition:back()
	local back_seg_len = back_seg.length

	local back_abc_r0 = back_seg:has_tag("abc") and back_seg_len % 3 == 0
	local back_abc_r2 = back_seg:has_tag("abc") and back_seg_len % 3 == 2

	local alphabet = schema_cfg:get_string('speller/alphabet') or ""
	local initials = schema_cfg:get_string('speller/initials') or ""

	if config.key2sym[key_repr:gsub("^Shift%+", "")] and back_abc_r0 then
		local symbol = config.key2sym[key_repr:gsub("^Shift%+", "")]
		if alphabet:find(symbol,1,true) and not initials:find(symbol,1,true) then
			if commit_text then
				env.engine:commit_text(commit_text)
				context:clear()
			end
		end
	elseif key_repr == "space" then
		if back_abc_r2 then
			context:push_input(" ")
			return 1 -- accepted
		elseif back_abc_r0 then
			env.engine:commit_text(commit_text)
			context:clear()
		end
	end

	return 2 -- noop
end

local T = {}

function T.init(env)
	local schema = Schema(env.engine.schema.schema_id or "")
	env.tran = Component.Translator(env.engine, schema, "translator", "script_translator")
end

function T.fini(env)
end

function T.func(input, seg, env)
	local context = env.engine.context
	local seg_end = seg.start

	local codes = split_input(input)
	local rem = codes.rem or ""

	local hangul = ""
	for _, code in ipairs(codes) do
		local success, ret = pcall(decode_syllable, code, maps)
		if not success then goto output end
		hangul = hangul..ret
		seg_end = seg_end + 3
	end

	seg_end = seg_end + #rem
	if rem:match("^[a-z]$") then
		if maps.key2onset[rem] then
			hangul = hangul..maps.key2onset[rem]
		end
	elseif rem:match("^[a-z].$") then
		local success, ret = pcall(decode_syllable, rem.." ", maps)
		if success then
			hangul = hangul..ret
		end
	end

	::output::
	hangul = hangul:gsub("^ ", "")
	if hangul == "" then return end
	yield(Candidate("hangul", seg.start, seg_end, hangul, " "))

	local t = env.tran:query(hangul, seg)
	if not t then return end
	for cand in t:iter() do
		yield(cand)
	end
end

return { tran=T, proc=P }
