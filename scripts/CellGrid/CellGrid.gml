#macro this self


function CellGrid(width, height) constructor {
	this.width = width
	this.height = height
	
	content = []
	
	clear = function() {
		for(var _x = 0; _x < width; _x++) {
			for(var _y = 0; _y < height; _y++) {
				content[_x][_y] = NewCell(CELL_TYPE.AIR)
			}
		}
	}
	
	clear()
	
	set = function(_x, _y, cell) {
		if !is_struct(cell)
			cell = NewCell(cell)
		cell.x = _x
		cell.y = _y
		cell.grid = this
		this.content[_x][_y] = cell
	}
	
	get = function(_x, _y) {
		return content[_x][_y]
	}
	
	inbounds = function(_x, _y) {
		return (_x >= 0 and _x < width and _y >= 0 and _y < height)
	}
	
	swap = function(x1, y1, x2, y2) {
		var cell1 = this.get(x1, y1)
		var cell2 = this.get(x2, y2)
		this.set(x2, y2, cell1)
		this.set(x1, y1, cell2)
		
		cell1.x = x2
		cell1.y = y2
		cell2.x = x1
		cell2.y = y1
	}
	
	remove = function(_x, _y) {
		this.set(_x, _y, CELL_TYPE.AIR)
	}
	
	// moved to Cell
	//// check if movement available
	//check = function(_x, _y, me) {
	//	if (_x >= width or _y >= height or _x < 0 or _y < 0)
	//		return true
		
	//	var cell = get(_x, _y)
	//	return (cell.state != STATE.GAS or cell.type == me.type)
	//}
	
	update = function() {
		for(var _x = 0; _x < width; _x++) {
			for(var _y = 0; _y < height; _y++) {
				content[_x][_y].updated = false
			}
		}
		
		for(var _x = 0; _x < width; _x++) {
			for(var _y = 0; _y < height; _y++) {
				var cell = content[_x][_y]
				
				if (cell.updated) continue
				
				cell.x = _x
				cell.y = _y
				cell.update()
				cell.updated = true
				
				if (cell.x != _x or cell.y != _y) {
					this.swap(cell.x, cell.y, _x, _y)
					//var new_cell = content[_x][_y]
					//if (!new_cell.updated) {
					//	new_cell.update()
					//	new_cell.updated = true
					//}
				}
			}
		}
	}
	
	draw = function(offx, offy) {
		for(var _x = 0; _x < width; _x++) {
			for(var _y = 0; _y < height; _y++) {
				var cell = content[_x][_y]
				
				if (cell.type == CELL_TYPE.AIR)
					continue
				
				cell.x = _x
				cell.y = _y
				
				//draw_get()
				
				cell.draw(offx + _x * CELL_WIDTH, offy + _y * CELL_HEIGHT)
				
				//draw_reset()
			}
		}
	}
}