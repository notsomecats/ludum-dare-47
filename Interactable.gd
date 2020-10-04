extends Area2D

signal show_label(text, position)
signal hide_label()

enum { BED, PC, EAT, WORK, TALK_1, TALK_2, TELEPORT }

export var type = TELEPORT
var in_range = false
var hud
var player
var enabled = true
var in_use = false
var random
var pc_messages
var pc_usernames = ["v4nqu1sh3r", "Bumpy", "Papa Solitude", "Dominant", "Havava", "Moonman", "Chahan Dorn", "Krakool"]
var can_pc_act = true
var words = ["bills", "old friends", "grandpa", "hummus", "pizza", "toast", "barbecue", "cats", "kittens", "puppies", "raccoons", "football", "broken mouse", "broken keyboard", "yesterday's report", "skin cancer", "urinals", "donuts", "marriage", "grammar", "spellcheck", "emails", "replies", "dentist", "toothpick", "cockroaches", "vegans", "steak", "pre-orders", "politics", "nuclear weapons", "plague", "memes", "manga", "anime", "weebs", "dementia", "that one thing", "I forgot", "I can't", "You can", "what", "when", "how", "who"]


var count_eat = 0
var count_npc1 = 0
var count_npc2 = 0


func _ready():
	random = RandomNumberGenerator.new()
	random.randomize()
	for member in get_tree().get_nodes_in_group("hud"):
		hud = member
	if $CanvasLayer/PCHome:
		$CanvasLayer/PCHome.visible = false
	if $CanvasLayer/PCWork:
		$CanvasLayer/PCWork.visible = false


func _process(delta):
	if enabled and in_range and Input.is_action_pressed("ui_accept"):
		activate()
		enabled = false
		$TimerCooldown.start()
	if in_use and Input.is_action_pressed("ui_cancel"):
		in_use = false
		$CanvasLayer/PCHome.visible = false
		$CanvasLayer/PCWork.visible = false
		$TimerUpdateTime.stop()
		$TimerPCHomeMessages.stop()
		player.set_status_idle()
	if in_use and can_pc_act and Input.is_action_pressed("ui_enter"):
		if type == PC:
			if hud.time < 5:
				hud.add_hp(-10)
			else:
				hud.add_hp(5)
			insert_pc_message("george", $CanvasLayer/PCHome/Input.text)
			$CanvasLayer/PCHome/Input.text = ""
		if type == WORK:
			if hud.time > 6 and hud.time < 19:
				hud.add_hp(40)
			else:
				hud.add_hp(-40)
			insert_pc_email($CanvasLayer/PCWork/Input.text)
			$CanvasLayer/PCWork/Input.text = ""
		can_pc_act = false
		$TimerPCActCooldown.start()


func set_player(spawned_player):
	player = spawned_player


func load_messages():
	return ["thank you!", ":D", "yesssss", "thank you!", ":D", "all i see is an arm, white splodges and blackness", "heck thats gnarly", "thank you im adding that to my list rn", "did you guys draw all of those?", "no", "mods can ban now", "yeah", "who are you banning?", "to do what", "which ones", "uh", "what do i do", "yeah", "can’t talk rn i’ll wake my bro", "i feel like i’d really want to listen to it for a long time tomorrow ????", "this is really nice", "okay", "cathy", "lol post songs", "no way, u did loads", "hm this server is more active than i thought i could make it in one day", "ash im kicking you out of this channel", "what does that mean", "cuzz those are excellent suggestions", "next time i have 3 hours to spare lel", "some day", "if not i will figure it out", "dou know how to do that? can i just make u admin?", "2 selfie channels how", "how do i", "excellent idea", "oh yeah", "idk what im doing", "so I'm going to start kicking", "i just removed all invites", "does anyone here actually want to write abuot internet definitions", "can i get some contributors to the internet protocol categories pls", "NO", "no diaper jokes", "no", "what the heck", "this server", "this server", "hey armin wahts up", "i fixed it", "there are msgs deleting before my eyes and idk how", "who deleting", "wait", "no hugboxes", "no", "u know what wab", "did u legit", "dont have spotify prem :(", "i have?", "my bf is mad, pls stop typing about this", "no i have a bf", "how r u?", "good morning conqueueror :D", "thats PERFECT", "i want to delete memes", "true", "ok", "how old r u brago", "wait", "wow", "how old r u.", "cybersmoke", "ok", "i shoudl not.", "no.", "should i make an introductions channel", "oh heck", "again", "afternoon", "thats not pinworthy", "how hot is it there ash", "england wbu", "cant take this,i should be naked right now", "its 27 degrees here", "right now", "im just too hot", "well i hope your headache goes away soon", "oh my god, 13 hours?", "from that", "i felt smething", "thats deep hat", "i did", "dont", "HI MIGI how are you", "is it better to have a life with lots of parties and mess or no party at all", "hello ulysses and poopman13 :D", "i need to know, i dont know what im doing with my life rn", "@everyone whats the meaning of life?", "ok seriously who is the dude in anonymous", "wow", "ok i want to listen to music w people", "my heart", "why would you joke about this", "4 ppl have asked me for rhythm", "aww man!", "awww<3", "hmm", "how come? wat does he do", "ub3rbot", "....compliment....i....think..", "a...", "wow.... that... is...", "snsn if u leave i leave", "NO", "funnie", "!!!!!!!!!", "misleading username", "fake", "ok", "why are we not a server gang right now??", "cybersmoke, onlinecomputergirl, alice on the internet", "i like ur username", "cybersmoke", "the youtub channel", "this channel seems interesting", ":D", "so do u guys like ddlg", "idek ar we not clappin no more??", ":DD", "hello eminem", "did u guys clap last thursday", "lizard hi", "wbu", "lol hah", "agre", "im boiling ", "too hot", "with the smirky smirky flush emoji posting", "fr who is that dude in annonymous", "so so so much", "huh", "wow", "feel like ppl who love music are usually INFP", "do u mean u werent online for 3 weeks at all, or just server?", "<2", "<4", "<4", "!lessthanthree", "did you feel better? im thinking of trying that", "no i need you in this server", "hello :DDDDD", "well", "omg", "no its the version", "is that the ip?", "poor ray william johnson", "why did you listen to it all just to give it 1 star", "i mean", "no i mean why did u rate it 1 star", "pardon", "i said that", "ME", "oooh god speed", "tell me more", "wow", "is pretty normal", "or", "apart from snsn", "probably the most normal in the entire server", "tats true u are very normal", "ill play minecraft with u", "that reminds me of an anime song", "of good stuff", "describe the genre", "i need to know what you listen to.", "rotterdam is alright now, no?", "hey google, why did brexit happen", "hello", "hey google, why did brexit happen?", "ah cool", "uhh i guess so?", "has been a running joke in british comedies for years", "the euro", "biritish ya", "LOL", "what are u talking abt sister", "i dont know. there is someting supsicous about her ", "hmm me too", "no", "dont rlly eat beef", "i hate that this is the current state of memes", "cant believe i just shared a meme. i hate myself.", "good MORNING LANA !", "does anyone enjoy mems? i dont", "tom and jerry"]


func _on_Interactable_area_entered(area):
	print_debug("_on_Interactable_area_entered")
	in_range = true
	var label_position = Vector2(position.x, position.y - 110)
	var label = "Unknown"
	if type == BED:
		label = "Sleep"
	elif type == EAT:
		label = "Eat"
	elif type == PC:
		label = "Play"
	elif type == WORK:
		label = "Work"
	else:
		label = "Talk"
	emit_signal("show_label", label, label_position)


func _on_Interactable_area_exited(area):
	in_range = false
	emit_signal("hide_label")


func activate():
	print_debug(type)
	if type == BED:
		activate_bed()
	elif type == PC:
		activate_pc()
	elif type == EAT:
		activate_fridge()
	elif type == WORK:
		activate_pc_work()
	elif type == TALK_1:
		activate_npc(1)
	elif type == TALK_2:
		activate_npc(2)


func activate_bed():
	print_debug("activate_bed")
	hud.fade_out()
	$TimerBed.start()


func activate_pc():
	print_debug("activate_pc")
	$CanvasLayer/PCHome.visible = true
	pc_messages = load_messages()
	$CanvasLayer/PCHome/Input.grab_focus()
	in_use = true
	player.set_status_busy()
	update_pc_time()
	$TimerUpdateTime.start()
	$TimerPCHomeMessages.start()
	if $CanvasLayer/PCHome/Messages.bbcode_text == "":
		print_debug("It's blank")
		for n in range(21):
			generate_random_pc_message()


func activate_pc_work():
	print_debug("activate_pc_work")
	if !$CanvasLayer/PCWork.visible:
		$CanvasLayer/PCWork.visible = true
		pc_messages = load_messages()
		$CanvasLayer/PCWork/Input.grab_focus()
		in_use = true
		player.set_status_busy()
		update_pc_time()
		next_email()
		$TimerUpdateTime.start()


func activate_fridge():
	var food = ["pizza", "meat pie", "granola bar", "hummus toast", "crackers", "chips", "chicken nuggets", "quesedillas", "dumpling", "meat patty"]
	var food_pre = ["burnt", "frozen", "half frozen", "old", "moist", "lukewarm", "lava hot", "hot", "warm", "kinda mouldy"]
	var food_do = ["enjoy", "devour", "eat", "munch-on"]

	if count_eat < 3:
		hud.add_log("You " + food_do[random.randi_range(0, food_do.size() - 1)] + " the " + food_pre[random.randi_range(0, food_pre.size() - 1)] + " " + food[random.randi_range(0, food.size() - 1)])
		hud.add_hp(15)
	elif count_eat < 6:
		hud.add_log("You are full, but you " + food_do[random.randi_range(0, food_do.size() - 1)] + " the " + food_pre[random.randi_range(0, food_pre.size() - 1)] + " " + food[random.randi_range(0, food.size() - 1)])
		hud.add_hp(-20)
	else:
		hud.add_log("You are hecking full, but you " + food_do[random.randi_range(0, food_do.size() - 1)] + " the " + food_pre[random.randi_range(0, food_pre.size() - 1)] + " " + food[random.randi_range(0, food.size() - 1)])
		hud.add_hp(-40)
	count_eat = count_eat + 1

func activate_npc(id):
	print_debug("activate_npc" + str(id))
	var npc_1 = [
		"He hasn't been the same since the divorce",
		"I can't believe he got the promotion instead",
		"Another kid? Don't you have like 7?",
		"He still hasn't given me back my pen",
		"Is that his 5th can of soda?",
		"We get it, you have kids",
		"That's actually a pretty nice haircut",
	]
	var npc_2 = [
		"She passive aggressively told me to get to work",
		"God she puts on way too much perfume",
		"\"Working hard or hardly working? Ha Ha\"",
		"\"Can't live without my morning coffee! ! !\"",
		"Another kid? Don't you have like 7?",
		"Did I just make a fool out of myself?",
		"We get it, you have a cat",
		"Why wasn't I invited to the wedding?",
	]
	var stop = [
		"Probably should stop now",
		"They look kinda annoyed at me",
		"Are they ignoring me now?",
		"I should stop talking probably",
		"Probably talking too much now",
	]
	if id == 1:
		count_npc1 = count_npc1 + 1
		if count_npc1 < 5:
			hud.add_log(npc_1[random.randi_range(0, npc_1.size() - 1)])
			hud.add_hp(5)
		else:
			hud.add_log(stop[random.randi_range(0, stop.size() - 1)])
			hud.add_hp(-10)
	elif id == 2:
		count_npc2 = count_npc2 + 1
		if count_npc2 < 5:
			hud.add_log(npc_2[random.randi_range(0, npc_2.size() - 1)])
			hud.add_hp(5)
		else:
			hud.add_log(stop[random.randi_range(0, stop.size() - 1)])
			hud.add_hp(-10)


func _on_TimerCooldown_timeout():
	enabled = true


func _on_TimerBed_timeout():
	if hud.time > 8 and hud.time < 15:
		hud.time = hud.time + 2
		hud.add_log("You can't tell if that was a good or terrible nap.")
		hud.add_hp(-10)
	else:
		hud.time = hud.time + 6
		hud.add_log("That was a pretty good sleep")
		hud.add_hp(40)
	hud.time = hud.time % 24
	hud.check_day_mode()
	hud.update_time()
	hud.fade_in()


func _on_TimerPCHomeMessages_timeout():
	generate_random_pc_message()


func generate_random_pc_message():
	var username = pc_usernames[random.randi_range(0, pc_usernames.size() - 1)]
	var message = pc_messages[random.randi_range(0, pc_messages.size() - 1)]
	insert_pc_message(username, message)
	$TimerPCHomeMessages.wait_time = rand_range(1, 2)
	$TimerPCHomeMessages.start()


func insert_pc_message(username, message):
	if message != "":
		var name = "[color=#6793A3]" + username + "[/color]: "
		$CanvasLayer/PCHome/Messages.bbcode_text = $CanvasLayer/PCHome/Messages.bbcode_text + name + message + "\n"


func insert_pc_email(message):
	if message != "":
		$CanvasLayer/PCWork/Messages.text = $CanvasLayer/PCWork/Messages.text + "\n\n-------------------\nGeorge Looper\n\n" + message + "\n"
		can_pc_act = false
		$TimerPCEmail.start()
		

func next_email():
	$CanvasLayer/PCWork/Messages.text = ""
	var names = ["Terry", "Janine", "Janice", "Griffany", "Patrick", "Sarge", "Mud", "Lauren", "Levy", "Thamas", "Nina", "Pim"]
	var titles = ["CEO Or Something", "Resident Sick Guy", "HR Manager", "Marketing Specialist", "Printer Fixer Guy", "Your Mother", "President of Break Room", "Princess of Zimbabwe", "IT Manager", "Software Developer", "Souless Sales Executive"]
	var greetings = ["Hey", "Yo", "Hello", "Greetings", "Hi George"]
	var first_lines = ["Did you know", "Do you happen to know", "So I was thinking about", "Terry said that with the", "Carrie wants 5 of the", "The other day I found out about", "Were you still working on", "When do you think you'll be done with"]
	var second_lines = ["doesn't seem to work", "didn't happen very fast", "couldn't fulfil our needs", "wasn't around when we needed it", "was too expensive", "didn't seem to be available"]
	var name = names[random.randi_range(0, names.size() - 1)]
	var title = titles[random.randi_range(0, titles.size() - 1)]
	var greeting = greetings[random.randi_range(0, greetings.size() - 1)]
	var first_line = first_lines[random.randi_range(0, first_lines.size() - 1)]
	var second_line = second_lines[random.randi_range(0, second_lines.size() - 1)]
	var first_word = words[random.randi_range(0, words.size() - 1)]
	var second_word = words[random.randi_range(0, words.size() - 1)]
	$CanvasLayer/PCWork/LabelName.text = name + "\n" + title
	$CanvasLayer/PCWork/Messages.text = greeting + ",\n\n" + first_line + " " + first_word + ". " + second_word.capitalize() + " " + second_line + "."


func update_pc_time():
	var time = hud.time
	var time_suffix = "PM"
	if time < 12:
		time_suffix = "AM"
	$CanvasLayer/PCHome/Time.text = str(time) + ":00 " + time_suffix
	$CanvasLayer/PCWork/Time.text = str(time) + ":00 " + time_suffix
	

func _on_TimerPCActCooldown_timeout():
	can_pc_act = true


func _on_TimerUpdateTime_timeout():
	update_pc_time()


func _on_TimerPCEmail_timeout():
	next_email()
