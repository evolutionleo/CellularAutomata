/// @desc

#macro CELL_WIDTH 8
#macro CELL_HEIGHT 8

width = room_width/CELL_WIDTH
height = room_height/CELL_HEIGHT

offx = 0
offy = 0


grid = new CellGrid(width, height)

setInterval(function() {
	trace("tick")
	_fps = round(fps_real)
	grid.update()
}, 10)


_fps = fps_real


brush_size = 0