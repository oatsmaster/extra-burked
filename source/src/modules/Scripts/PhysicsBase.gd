class_name PhysicsBase extends Node3D


@export var playerBody: CharacterBody3D;
@export var externalMovements: Array[CustomMovement]; 
@export_category("Physics Settings")
@export var gravity := 9.81; #meters per second squared
@export var mass := 10; #kilograms
@export var maxSpeed := 10; #meters per second
@export var maxAcceleration := 10; #meters per second squared
@export var jumpForce := 4.5; #meters per second squared (impulse)
var currentVelocity = Vector3(0, 0, 0);

func _ready():
	playerBody.set_floor_stop_on_slope_enabled(true);

func _physics_process(delta):
	var currentForce := Vector3(0, 0, 0);
	var floored = playerBody.is_on_floor();
	
	var averageFriction = get_average_friction();
	
	# Gravity
	var forceGravity = Vector3.DOWN * gravity * mass * delta;
	currentForce += forceGravity;
	
	# Normal Force
	var forceNormal = Vector3(0, 0, 0);
	if(floored):
		if(currentForce.dot(playerBody.get_floor_normal()) < 0):
			var normal = playerBody.get_floor_normal();
			forceNormal -= currentForce.project(normal);
			currentVelocity -= currentVelocity.project(normal);
	if(playerBody.is_on_wall()):
		if(currentForce.dot(playerBody.get_wall_normal()) < 0):
			var normal = playerBody.get_wall_normal();
			forceNormal -= currentForce.project(normal);
			currentVelocity -= currentVelocity.project(normal);
	currentForce += forceNormal;
	
	#Applied Forces
	if(externalMovements.size() > 0):
		for movement in externalMovements:
			currentForce += movement.Main(delta);
			
	if(playerBody.is_on_ceiling()): currentVelocity.Y = 0;
	
	currentVelocity += 2 * (currentForce / mass);
	
	playerBody.velocity = currentVelocity;
	playerBody.move_and_slide();
	
func get_average_friction():
	var collisionCount = playerBody.get_slide_collision_count();
	var averageFriction = 0;
	if(collisionCount == 0): return 0;
	for i in collisionCount:
		var collider = playerBody.get_slide_collision(i).get_collider();
		if(collider.physics_material_override == null): averageFriction += 1;
		else: averageFriction += collider.physics_material_override.friction;
	averageFriction /= collisionCount;
	return averageFriction;
