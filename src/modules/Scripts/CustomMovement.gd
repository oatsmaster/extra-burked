class_name CustomMovement extends CharacterBody3D

var pendingForce = Vector3(0, 0, 0);
var parent

func _init(givenParent: PhysicsBase):
	parent = givenParent;
