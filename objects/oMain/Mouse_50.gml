/// @desc

var type = CELL_TYPE.AIR

if keyboard_check(ord("S"))
	type = CELL_TYPE.STONE
else if keyboard_check(ord("A"))
	type = CELL_TYPE.SAND
else if keyboard_check(ord("D"))
	type = CELL_TYPE.WOOD
else if keyboard_check(ord("W"))
	type = CELL_TYPE.WATER
else if keyboard_check(ord("F"))
	type = CELL_TYPE.FIRE
else if keyboard_check(ord("T"))
	type = CELL_TYPE.STEAM
else if keyboard_check(ord("G"))
	type = CELL_TYPE.GUNPOWDER
else if keyboard_check(ord("P"))
	type = CELL_TYPE.PLANT
else if keyboard_check(ord("C"))
	type = CELL_TYPE.ACID


for(var dir = 0; dir < 360; dir += 15) {
	for(var l = 0; l <= brush_size; l++) {
		var dx = lengthdir_x(l*CELL_WIDTH, dir)
		var dy = lengthdir_y(l*CELL_WIDTH, dir)
	
		var cell_x = (mouse_x + dx - offx) div CELL_WIDTH
		var cell_y = (mouse_y + dy - offy) div CELL_HEIGHT
	
		if (cell_x >= 0 and cell_x < width and cell_y >= 0 and cell_y < height)
			grid.set(cell_x, cell_y, type)
	}
}