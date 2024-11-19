LIST OF COMMANDS AND THEIR SYNTAX:

using the commands with incorrect syntax may cause the game to crash, just re-open it and
it will all be fine

you can open the developer console by pressing `

	~LIST OF COMMANDS~
 
	• 'clear' - clears the output of the console


	• 'gd.runline<<' (and then the code) - runs line/s of gdscript 4.3 that extends a node and is called in func _ready()
				               (note that to do new lines, use the shortcut '//nln' and '//tb' for tabs)
		   			       using this could, technically, allow you to 'mod' the game, if you would call
	                                       it that (in the 'gd.runline<<' you cannot leave any spaces at the beginning of the command.
					       be very careful using this command as it can easily crash the game if done incorrectly)


	• 'new' (and then the path) - creates a new instance of the scene from the given path (starting with 'res://',
				       e.g. 'res://scenes/bullet.tscn'). shortcuts are 'enemy' for a square enemy, 'player'
				       for a player, 'mapend' for the end to a level, and 'enemyv2' for the seccond variation
				       of enemy


	• 'map' (and then the path) - changes the scene to the given path (without the .tscn extension) ('level' is a
                                      shortcut for 'res://scenes/level', 'menu' is a shortcut for the menu. there are 9 levels, level9 being the credits.)


	• 'unlockall' - unlocks all the maps


 	• 'infinitehealth' (and then 1 or 0 [optional]) - gives the player infinite health or takes it away (based on 
                                                          whether you typed 1 or 0) until you complete the level


 	• 'player.' (and then either 'get_' or 'set_') - 'get' gets the requested property of the player, e.g.
                                                         'player.get_speed' and 'set' sets the player's given property
							 (note that it has to include the property type),
	                                                 e.g. 'player.set_velocity vec 1000,1000' or 
                                                         'player.set_health int 6' (constructors: int, float, string, vec, 
                                                         bool)

  	• 'pause' - pauses the tree

   	• 'unpause' - unpauses the tree
