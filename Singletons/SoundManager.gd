extends Node

const SFX_SOUNDS_POWERUP_1 = preload("res://assets/sounds/Positive Sounds/sfx_sounds_powerup1.wav")
const SFX_SOUNDS_POWERUP_2 = preload("res://assets/sounds/Positive Sounds/sfx_sounds_powerup2.wav")
const SFX_SOUNDS_POWERUP_3 = preload("res://assets/sounds/Positive Sounds/sfx_sounds_powerup3.wav")
const SFX_SOUNDS_POWERUP_4 = preload("res://assets/sounds/Positive Sounds/sfx_sounds_powerup4.wav")
const SFX_SOUNDS_POWERUP_5 = preload("res://assets/sounds/Positive Sounds/sfx_sounds_powerup5.wav")
const SFX_SOUNDS_POWERUP_6 = preload("res://assets/sounds/Positive Sounds/sfx_sounds_powerup6.wav")
const SFX_SOUNDS_POWERUP_7 = preload("res://assets/sounds/Positive Sounds/sfx_sounds_powerup7.wav")
const SFX_SOUNDS_POWERUP_8 = preload("res://assets/sounds/Positive Sounds/sfx_sounds_powerup8.wav")
const SFX_SOUNDS_POWERUP_9 = preload("res://assets/sounds/Positive Sounds/sfx_sounds_powerup9.wav")


const GASP_1 = preload("res://assets/sounds/gasp1.wav")
const GASP_2 = preload("res://assets/sounds/gasp2.wav")
const GASP_3 = preload("res://assets/sounds/gasp3.wav")

const SFX_EXP_MEDIUM_4 = preload("res://assets/sounds/sfx_exp_medium4.wav")
const SFX_WPN_LASER_2 = preload("res://assets/sounds/sfx_wpn_laser2.wav")

const TADA_FANFARE_A_6313 = preload("res://assets/sounds/winning/tada-fanfare-a-6313.mp3")
const LOOP_013438_SYNTH_LOOP_2_57862 = preload("res://assets/sounds/music/loop-013438_synth-loop-2-57862.mp3")

const POWER_UP = [
	SFX_SOUNDS_POWERUP_1,
	SFX_SOUNDS_POWERUP_2,
	SFX_SOUNDS_POWERUP_3,
	SFX_SOUNDS_POWERUP_4,
	SFX_SOUNDS_POWERUP_5,
	SFX_SOUNDS_POWERUP_6,
	SFX_SOUNDS_POWERUP_7,
	SFX_SOUNDS_POWERUP_8,
	SFX_SOUNDS_POWERUP_9,
]

const GASP = [
	GASP_1,
	GASP_2,
	GASP_3
]


func play(sound:AudioStreamPlayer2D, audio ) -> void:
	if GameManager.get_sound():
		sound.stream = audio
		sound.play()


func play_gasp(sound:AudioStreamPlayer2D) -> void:
	var audio = GASP.pick_random()
	play(sound, audio)


func play_powerup(sound:AudioStreamPlayer2D) -> void:
	var audio = POWER_UP.pick_random()
	play(sound, audio)


func play_boom(sound:AudioStreamPlayer2D) -> void:
	var audio = SFX_EXP_MEDIUM_4
	play(sound, audio)


func play_laser(sound:AudioStreamPlayer2D) -> void:
	var audio = SFX_WPN_LASER_2
	play(sound, audio)


func play_win(sound:AudioStreamPlayer2D) -> void:
	var audio = TADA_FANFARE_A_6313
	play(sound, audio)


func play_soundtrack(sound:AudioStreamPlayer) -> void:
	var audio = LOOP_013438_SYNTH_LOOP_2_57862
	sound.stream = audio

	if GameManager.get_music():
		sound.play()


func stop(sound:AudioStreamPlayer2D) -> void:
	sound.stop()

