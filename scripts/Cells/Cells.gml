enum CELL_TYPE {
	UNDEFINED = -1,
	AIR = 0,
	WOOD = 1,
	SAND = 2,
	WATER = 3,
	FIRE = 4,
	STEAM = 5,
	STONE = 6,
	GUNPOWDER = 7,
	PLANT = 8,
	ACID = 9,
	ASH = 10
}

enum STATE {
	UNDEFINED = -1,
	SOLID = 1,
	LIQUID = 2,
	GAS = 3
}

#macro CellLib global._CellLib

global._CellLib = [
	/* 0 */	AirCell,
	/* 1 */	WoodCell,
	/* 2 */	SandCell,
	/* 3 */	WaterCell,
	/* 4 */	FireCell,
	/* 5 */	SteamCell,
	/* 6 */	StoneCell,
	/* 7 */	GunpowderCell,
	/* 8 */	PlantCell,
	/* 9 */	AcidCell,
	/* 10 */AshCell
]


function NewCell(type) {
	var cell_constructor = CellLib[type]
	return new cell_constructor()
}

function Cell() constructor {
	this.grid = undefined
	this.type = CELL_TYPE.UNDEFINED
	
	this.x = undefined
	this.y = undefined
	
	this.updated = true // skip the first tick
	
	// tags
	this.state = STATE.UNDEFINED
	this.flameable = 0
	
	update = function() {
		
	}
	
	draw = function(_x, _y) {
		
	}
	
	static check = function(_x, _y) {
		if (_x >= grid.width or _y >= grid.height or _x < 0 or _y < 0)
			return true
		
		var cell = grid.get(_x, _y)
		return (cell.state != STATE.GAS or cell.type == this.type)
	}
}


function AirCell() : Cell() constructor {
	this.type = CELL_TYPE.AIR
	
	this.state = STATE.GAS
	
	update = function() { }
	draw = function(_x, _y) { }
}

function WoodCell() : Cell() constructor {
	this.type = CELL_TYPE.WOOD
	
	this.state = STATE.SOLID
	this.flameable = .4
	
	update = function() { }
	draw = function(_x, _y) {
		draw_sprite(sWood, 0, _x, _y)
	}
}

function SandCell() : Cell() constructor {
	this.type = CELL_TYPE.SAND
	this.state = STATE.SOLID
	
	update = function() {
		var side = choose(-1, 1)
		
		if !check(x, y+1)
			y += 1
		else if grid.inbounds(x, y+1) and grid.get(x, y+1).state == STATE.LIQUID { // fill the liquids
			grid.remove(x, y+1)
			y += 1
		}
		else if !check(x+side, y+1) {
			x += side
			y += 1
		}
		else if !check(x-side, y+1) {
			x -= side
			y += 1
		}
	}
	
	draw = function(_x, _y) {
		draw_sprite(sSand, 0, _x, _y)
	}
}

function WaterCell() : Cell() constructor {
	this.type = CELL_TYPE.WATER
	this.state = STATE.LIQUID
	
	trymove = function(_x, _y) {
		if !grid.inbounds(_x, _y)
			return false
		
		var cell = grid.get(_x, _y)
		if cell.type == CELL_TYPE.FIRE {
			grid.set(_x, _y, CELL_TYPE.STEAM)
			grid.set(x, y, CELL_TYPE.AIR)
			return true
		}
		else if !check(_x, _y) {
			x = _x
			y = _y
			return true
		}
		
		return false
	}
	
	update = function() {
		var side = choose(-1, 1)
		var _ = trymove(x, y+1) or trymove(x-side, y+1) or trymove(x+side, y+1) or trymove(x+side, y) or trymove(x-side, y)
	}
	
	draw = function(_x, _y) {
		draw_sprite(sWater, 0, _x, _y)
	}
}

function FireCell() : Cell() constructor {
	this.type = CELL_TYPE.FIRE
	this.state = STATE.LIQUID
	this.fired = false
	
	this.fall_timer = 2
	this.life_timer = 4
	
	process = function(_x, _y) {
		if grid.inbounds(_x, _y) {
			var cell = grid.get(_x, _y)
			
			if (cell.flameable > 0) {
				if random(1) < cell.flameable
					grid.set(_x, _y, CELL_TYPE.FIRE)
				this.fired = true
			}
		}
	}
	
	update = function() {
		// 4 directions
		process(x+1, y)
		process(x-1, y)
		process(x, y+1)
		process(x, y-1)
		// diagonals
		process(x+1, y+1)
		process(x+1, y-1)
		process(x-1, y+1)
		process(x-1, y-1)
		
		if fall_timer > 0
			fall_timer--
		else { // fall
			if grid.inbounds(x, y+1) {
				var cell_below = grid.get(x, y+1)
				if cell_below.type == CELL_TYPE.WATER { // if contacting water
					grid.set(x, y, CELL_TYPE.STEAM)
					grid.remove(x, y+1)
				}
				else if !check(x, y+1)
					y += 1
			}
		}
		
		if this.fired
			grid.set(x, y, CELL_TYPE.AIR)
		
		if life_timer > 0
			life_timer--
		else
			grid.set(x, y, CELL_TYPE.AIR)
	}
	
	draw = function(_x, _y) {
		draw_sprite(sFire, 0, _x, _y)
	}
}

function SteamCell() : Cell() constructor {
	this.type = CELL_TYPE.STEAM
	
	this.state = STATE.GAS
	this.flameable = 0
	
	update = function() {
		var side = choose(-1, 1)
		
		if !check(x, y-1) {
			y -= 1
		}
		else if !check(x+side, y-1) {
			x += side
			y -= 1
		}
		else if !check(x-side, y-1) {
			x -= side
			y -= 1
		}
		else if !check(x+side, y) {
			x += side
		}
		else if !check(x-side, y) {
			x -= side
		}
	}
	
	draw = function(_x, _y) {
		draw_sprite(sSteam, 0, _x, _y)
	}
}

function StoneCell() : Cell() constructor {
	this.type = CELL_TYPE.STONE
	this.state = STATE.SOLID
	
	update = function() { }
	
	draw = function(_x, _y) {
		draw_sprite(sStone, 0, _x, _y)
	}
}

function GunpowderCell() : Cell() constructor {
	this.type = CELL_TYPE.GUNPOWDER
	this.flameable = .6
	this.state = STATE.SOLID
	
	update = function() {
		var side = choose(-1, 1)
		
		if !check(x, y+1)
			y += 1
		else if !check(x+side, y+1) {
			x += side
			y += 1
		}
		else if !check(x-side, y+1) {
			x -= side
			y += 1
		}
	}
	
	draw = function(_x, _y) {
		draw_sprite(sGunpowder, 0, _x, _y)
	}
}

function PlantCell() : Cell() constructor {
	this.type = CELL_TYPE.PLANT
	
	this.state = STATE.SOLID
	this.flameable = .8
	
	process = function(_x, _y) {
		var cell = grid.get(_x, _y)
		if cell.type == CELL_TYPE.WATER {
			grid.set(_x, _y, CELL_TYPE.PLANT)
		}
	}
	
	update = function() {
		process(x-1, y)
		process(x+1, y)
		process(x, y-1)
		process(x, y+1)
		
		process(x-1, y-1)
		process(x-1, y+1)
		process(x+1, y-1)
		process(x+1, y+1)
	}
	
	draw = function(_x, _y) {
		draw_sprite(sPlant, 0, _x, _y)
	}
}

function AcidCell() : Cell() constructor {
	this.type = CELL_TYPE.ACID
	
	this.dissolved = false
	
	this.state = STATE.LIQUID
	this.flameable = .7
	
	process = function(_x, _y) {
		if !grid.inbounds(_x, _y)
			return -1
		
		var cell = grid.get(_x, _y)
		if cell.type == CELL_TYPE.GUNPOWDER or cell.type == CELL_TYPE.STONE or cell.type == CELL_TYPE.WOOD or cell.type == CELL_TYPE.PLANT {
			grid.set(_x, _y, CELL_TYPE.ACID)
		}
	}
	
	trymove = function(_x, _y) {
		if !grid.inbounds(_x, _y)
			return false
		
		var cell = grid.get(_x, _y)
		if cell.type == CELL_TYPE.WATER {
			grid.set(_x, _y, CELL_TYPE.STEAM)
			grid.set(x, y, CELL_TYPE.AIR)
			this.dissolved = true
			return true
		}
		else if !check(_x, _y) {
			x = _x
			y = _y
			return true
		}
		
		return false
	}
	
	update = function() {
		this.dissolved = false
		
		var side = choose(-1, 1)
		var _ = trymove(x, y+1) or trymove(x-side, y+1) or trymove(x+side, y+1) or trymove(x+side, y) or trymove(x-side, y)
		
		
		if (!this.dissolved) {
			process(x-1, y)
			process(x+1, y)
			process(x, y-1)
			process(x, y+1)
		
			process(x-1, y-1)
			process(x-1, y+1)
			process(x+1, y-1)
			process(x+1, y+1)
		}
	}
	
	draw = function(_x, _y) {
		draw_sprite(sAcid, 0, _x, _y)
	}
}

function AshCell() : Cell() constructor {
	this.type = CELL_TYPE.ASH
	this.state = STATE.SOLID
	
	update = function() {
		var side = choose(-1, 1)
		
		if !check(x, y+1)
			y += 1
		else if grid.inbounds(x, y+1) and grid.get(x, y+1).state == STATE.LIQUID { // fill the liquids
			grid.remove(x, y+1)
			y += 1
		}
		else if !check(x+side, y+1) {
			x += side
			y += 1
		}
		else if !check(x-side, y+1) {
			x -= side
			y += 1
		}
	}
	
	draw = function(_x, _y) {
		draw_sprite(sSand, 0, _x, _y)
	}
}