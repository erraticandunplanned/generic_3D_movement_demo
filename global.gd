extends Node

const PORT = 8910
var upnp = UPNP.new()

var gravity = 20
var paused = false
var jump_on_release = false
var directional_walljump = false
var dynamic_fov = true

var joystick_camera_lock = false
var first_person_camera = true
