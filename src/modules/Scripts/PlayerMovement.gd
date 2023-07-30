class_name PlayerMovement extends CustomMovement

func main(_delta):
	var playerBody : CharacterBody3D = parent.playerBody;
	var mass : float = parent.mass;
	var maxAcceleration : float = parent.maxAcceleration;
	var maxSpeed : float = parent.maxSpeed;
	var dragCoefficient : float = parent.dragCoefficient;
	var jumpForce : float = parent.jumpForce;
	
	var floored : bool = playerBody.is_on_floor();
	var averageFriction : float = parent.get_average_friction();
	var currentForce : Vector3 = Vector3(0, 0, 0);
	var currentVelocity : Vector3 = parent.currentVelocity;
	
	# Movement Force
	var desiredVelocity2D := Input.get_vector("left","right","forward","backward").normalized() * maxSpeed;
	var desiredVelocity3D : Vector3 = desiredVelocity2D.x * playerBody.global_transform.basis.x + desiredVelocity2D.y * playerBody.global_transform.basis.z;
	var currentHorizontalVelocity := Vector3(currentVelocity.x, 0, currentVelocity.z);
	var movementAcceleration := (desiredVelocity3D - currentHorizontalVelocity) * .5;
	if(floored):
		movementAcceleration = movementAcceleration.limit_length(maxAcceleration * _delta * .5 * averageFriction);
	else:
		movementAcceleration = movementAcceleration.limit_length(maxAcceleration * _delta * .5 * dragCoefficient);
	
	currentForce += movementAcceleration * mass;
	
	#Jump Force
	var forceOfJump := Vector3(0, 0, 0);
	if(floored):
		parent.currentVelocity.y = 0;
		if(Input.is_action_pressed("jump")):
			forceOfJump.y = jumpForce * mass;
			currentForce += forceOfJump;
			
	return currentForce
