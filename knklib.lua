local knklib = {}
local http = require("http.request")
local http_util = require("http.util")
local cjson = require("cjson.safe")

local knk = "https://ogmmateryal.eba.gov.tr/yapayzeka/api/Question/Sentencetest/"

function knklib.ask(text)
	local coded = http_util.encodeURI(text)
	local headers, stream = assert(http.new_from_uri(knk .. coded):go())
	local body = assert(stream:get_body_as_string(), "No body")

	local value, error = cjson.decode(body)
	assert(value, "Couldn't decode JSON: " .. (error or ""))

	local processed_value = {}
	if value.errors ~= cjson.null or not value.data then return nil end

	for i, v in ipairs(value.data) do
		processed_value[i] = {
			topic_id = v.konuid,
			extension_number = v.ekozellikno,
			score = v.score,
			--Multiple fallbacks, in case the response changes
			text = v.userText or v.fullText or v.konu,
			user_text = v.userText,
			full_text = v.fullText,
			full_text_with_suffix = v.fullTextWithEk,
			grade = v.sinif,
			class = v.ders,
			topic = v.konu,
			subtopic = v.altkonu,
			index = v.indis,
			url = v.url,
			urltext = v.urltext,
			id = v.id,
			creation_date = v.createdDate
		}
	end

	return processed_value
end

return knklib
