local knk = require("knklib")
local inputprefix = "> "
local outputprefix = "* "
local verbose = arg[1] == "verbose"

while true do
	io.write(inputprefix)
	local line = io.read("*l")

	local result = knk.ask(line)
	if not result then
		io.write("Ne dediğin tam olarak anlaşılamadı, daha açık ve net bir şekilde yazabilir misin?\n")
	else
		io.write("Şunları yapabilirsin:\n")

		for _, v in ipairs(result) do
			io.write(outputprefix .. (v.text or "[yazı alınamadı]") .. "\n")
			if verbose then
				for k, w in pairs(v) do
					io.write(outputprefix .. outputprefix)
					io.write(k .. ": " .. tostring(w) .. "\n")
				end
			end
		end
	end
end
