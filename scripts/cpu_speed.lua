--------------------------------------------------------
-- Set N3DS speed
--------------------------------------------------------
model = System.getModel()
if(model == 2 or model == 4) then
	System.setCpuSpeed(NEW_3DS_CLOCK)
end