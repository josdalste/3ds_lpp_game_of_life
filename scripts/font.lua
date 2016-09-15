--------------------------------------------------------
-- Text Parsing for Bitmap based font
--------------------------------------------------------
characters = {}
characters["0"] = 0
characters["1"] = 1
characters["2"] = 2
characters["3"] = 3
characters["4"] = 4
characters["5"] = 5
characters["6"] = 6
characters["7"] = 7
characters["8"] = 8
characters["9"] = 9
characters["A"] = 10
characters["B"] = 11
characters["C"] = 12
characters["D"] = 13
characters["E"] = 14
characters["F"] = 15
characters["G"] = 16
characters["H"] = 17
characters["I"] = 18
characters["J"] = 19
characters["K"] = 20
characters["L"] = 21
characters["M"] = 22
characters["N"] = 23
characters["O"] = 24
characters["P"] = 25
characters["Q"] = 26
characters["R"] = 27
characters["S"] = 28
characters["T"] = 29
characters["U"] = 30
characters["V"] = 31
characters["W"] = 32
characters["X"] = 33
characters["Y"] = 34
characters["Z"] = 35
characters["?"] = 36
characters[":"] = 37
--characters["-"] = 36
--characters["*"] = 37
--characters["''"] = 38

--characters["?"] = 40
--characters["!"] = 41
--characters["/"] = 42
--characters["."] = 43
characters[" "] = 38
--------------------------------------------------------
-- Break the string down
--------------------------------------------------------
function screen_text(sentence, xloc, yloc)
	length = string.len(sentence) - 1
	-- Makes the sentence upper case
	new_sentence = string.upper(sentence)
	-- Breaks the sentence into individual letters
	for txt = 0, length do
		_G["severed_sentence"] = string.sub(new_sentence, txt + 1, txt + 1)
		Graphics.drawPartialImage(xloc+(8 * txt), yloc, (8 * characters[_G["severed_sentence"]]), 0, 8, 16, font)
	end
end