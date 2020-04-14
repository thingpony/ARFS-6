/obj/machinery/computer/ship/weapons
	name = "weapon console"
	icon_keyboard = "teleport_key"
	icon_screen = "teleport"
	light_color = "#77fff8"
	circuit = /obj/item/weapon/circuitboard/sensors
	extra_view = 4
	var/list/weapons = list()

/obj/machinery/computer/ship/weapons/attempt_hook_up(obj/effect/overmap/visitable/ship/sector)
	if(!(. = ..()))
		return
	find_weapons()

/obj/machinery/computer/ship/weapons/proc/find_weapons()
	if(!linked)
		return
	weapons.Cut()
	for(var/obj/machinery/shipweapon/W in global.machines)
		if(linked.check_ownership(W))
			weapons |= W
			break

/obj/machinery/computer/ship/weapons/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!linked)
		display_reconnect_dialog(user, "weapons")
		return

	var/data[0]

	data["viewing"] = viewing_overmap(user)
	data["weapons"] = list()
	for(var/obj/machinery/shipweapon/W in weapons)
		weapons[W.name] = list(W.ammostring, W.ammo, W.maxammo)

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "shipweapons.tmpl", "[linked.name] Weapon Control", 420, 530, src)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/ship/weapons/OnTopic(var/mob/user, var/list/href_list, state)
	if(..())
		return TOPIC_HANDLED

	/*
	if (!linked)
		return TOPIC_NOACTION

	if (href_list["viewing"])
		if(user && !isAI(user))
			viewing_overmap(user) ? unlook(user) : look(user)
		return TOPIC_REFRESH

	if (href_list["link"])
		find_sensors()
		return TOPIC_REFRESH

	if(sensors)
		if (href_list["range"])
			var/nrange = input("Set new sensors range", "Sensor range", sensors.range) as num|null
			if(!CanInteract(user,state))
				return TOPIC_NOACTION
			if (nrange)
				sensors.set_range(CLAMP(nrange, 1, world.view))
			return TOPIC_REFRESH
		if (href_list["toggle"])
			sensors.toggle()
			return TOPIC_REFRESH

	if (href_list["scan"])
		var/obj/effect/overmap/O = locate(href_list["scan"])
		if(istype(O) && !QDELETED(O) && (O in view(7,linked)))
			playsound(loc, "sound/machines/dotprinter.ogg", 30, 1)
			new/obj/item/weapon/paper/(get_turf(src), O.get_scan_data(user), "paper (Sensor Scan - [O])")
		return TOPIC_HANDLED
	*/

/obj/machinery/computer/ship/weapons/process()
	..()
	if(!linked)
		return
	/*
	if(sensors && sensors.use_power && sensors.powered())
		var/sensor_range = round(sensors.range*1.5) + 1
		linked.set_light(sensor_range + 0.5, 4)
	else
		linked.set_light(0)
	*/

/obj/machinery/shipweapon
	name = "he missile pod"
	desc = "Pre-packaged pod of high-explosive missiles for ship-to-ship combat."
	icon = 'icons/obj/shipweapons.dmi'
	icon_state = "missilepod"
	anchored = 1
	
	var/ammo = 5
	var/maxammo = 5
	var/ammostring = "high-explosive guided missiles"
	var/ammotype = /obj/effect/meteor/missile/exp
	var/guided = TRUE

/obj/machinery/shipweapon/emp
	name = "emp missile pod"
	desc = "Pre-packaged pod of emp missiles for ship-to-ship combat."
	icon_state = "missilepod_emp"
	
	ammostring = "emp guided missiles"
	ammotype = /obj/effect/meteor/missile/emp