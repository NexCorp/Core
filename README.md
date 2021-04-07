![](https://i.imgur.com/eVlpIQq.png)

# Nexus Core

Community Support NexCorp Discord: https://discord.gg/rmCv7UJVPD
See the wiki: https://github.com/NexCorp/Core/wiki

**What is?**
ESX 1.2 Extended Version 

This version of the original kernel has been modified for the exclusive use of the servers **Nexus Life** *(closed*), **Goodlife RP** *(closed)*, **Aftermath AP**, **El Condado RP** and other servers of their same creators. 

Although this modification was private, the developers have chosen to release a (not final) version of a working kernel for certain purposes. We believe that the community does not value the work of developers very much, 
**always looking to steal the work of others**. To avoid this event again in our history, it has been launched, so that those who know what they are doing, can edit it, improve it and above all continue working on it, for those who want to make it stronger and more robust.


## Our history
We were born from the cave of wolves, looking to innovate, but without wasting time, we found ESX, specifically version 1.2, which to our liking, was the best that would help us to easily modify and implement. We build a server at our discretion, based on the criticism and opinions of our community, which by the way, we are developers from Chile, although the **main director of this project has been AlexBanPer (Alejandro Martínez) in its entirety**. Although, we were not so well known in the world, we had our days of fame, although really everything is exhausted when small communities start dividing like cells exponentially and divide the same people, with 10, 20 or even 30 new servers every day.

Well, let's stop with sad stories that probably few will read and let's go with what matters.

![](https://i.imgur.com/kKxbuBi.png)

**Condition**
These scripts were quickly converted from an in-house project to open source, so they are not well suited for third-party use yet. Improving this adaptation is one of the top development priorities, specifically:

 - Many of the scripts are dependent on each other.
 - Network functions are completely disabled with external connections.
 - Documentation for third parties (eg "how do I run this?")
 - Some scripts do not have a proper configuration file, so the source code must be modified.
 
**Private Extensions**

We are worked hard to make some scripts, sincerely these scripts are made with love. So, some scripts like **Nexus Anti Cheat** *(NAC)*, **Factions Manager** *(NFM)*, **Nexus Administration** *(NAD)*, **NAC Assistant** *[DiscordBot] (NAS)*, **Nexus SYNC** *(NESY)*, Nex Vehicles *(NEV)* and **Metabolism UI** *(NEMUI)* are private scripts for now...

 **Why?** Simply. This is our work, the majory are working in the server side, so, this can't be leaked easily.  Contact with *AlexBanPer* for more information.
 Maybe in some time, this scripts may be released  for open source.

Remember, the **most feature of this is the possibility to create multi characters** in the same core (with some extensions as nex_characters) 

However, we want to publish and expand this resource further, so that everyone can undertake a new server or modify your actual. 
 

Important:

: **IT IS POSSIBLE** to migrate **ANY** script from **ESX to NEX** (see below).

![enter image description here](https://i.imgur.com/U0sACR9.png)

|  SCRIPT NAME | VERSION | LANGUAGE | Description | Status 
|--|--|--| -- | -- |
| nex_core | 2.0 | LUA, HTML, CSS & JS | Core of everything | Deployed Open Source
| nex_administration | 1.0 | LUA | Main Menu for administration of characters, punishments and NAC features | Closed Source
| nex_characters | 1.2 | LUA, HTML, CSS & JS | Character Manager | Work for deploy
| nex_basic | 2.0 | LUA | Basic functions for RP (or any) server. Over 20 modular functions | Work for deploy
| nex_hifi | 2.0 | LUA | Radio in game, (*movable with nex_factions*) With entity and sound tracking | Work for deploy

See more in [Extensions for NexCore](https://github.com/NexCorp/Core/wiki/Extensions)

![](https://i.imgur.com/QwDvwLq.png)

----
**Attention:** Using the core by itself will NOT allow you to create multiple characters, and you must wait for the launch of the nex_characters extension (full control of the characters) but you can develop for nex_core in the meantime.

The core has been created by and for a Spanish community, so literally any native ESX translation file was omitted, any translation must be implemented in your native language, dear developer.

----

**NEX Core offers stability**, coming from the previous versions of ESX, Nex Core was modified to create multiple characters from the server base, without the need to adapt other scripts, although yes, to create modifications to it, we must always think in two or more, no longer in one.

This modification contemplates the following: 
 - New administrative commands .
 - New systems totally rewritten for greater stability.
 - New synchronization systems.
 - New xPlayer functions.
 - New client / server functions.
 - New integrated notifications.
 - Fixes of functions that required stability.
 - Live reload of jobs.
 - Live reloading of the waiting queue.
 - 7 new types of logs for Discord.
 - (WIP) Client security for code injections
 - Automatic script start system.
 - Hard reset of all scripts without causing problems.
 - Multiple jobs for each character (WIP)
 - Some other admin and player commands.
 - Paycheck with bonuses and taxes for vips.
 - Much more content with mods for NEX

![enter image description here](https://i.imgur.com/6hAu8Rk.png)

We will be working on a cautious WIKI, for all those who have no programming knowledge, however we will leave the simplest.

**For each client side script:**

 1. Add in `config_s.lua` -> `ConfigServer.SecureResources` the name of the resources.
 2. In the client side, for e.g `main.lua` replace the common esx thread for:

```
NEX = nil -- Can be ESX if you want
Citizen.CreateThread(function()
	while NEX == nil  do
		TriggerEvent('nexus:getNexusObject', GetCurrentResourceName(), function(obj)
	 		NEX = obj
		end)
		Citizen.Wait(50)
    end
 end)
```

**For each server side script:**

 1. You can hold the same code or change ESX variable to NEX, but you must change the event handler for:
```
TriggerEvent('nexus:getNexusObject', function(obj) NEX = obj end)
```
And ready! You are already working with NEX Core for your server, now we have to wait to install extensions.  

**We strongly recommend not installing nex core for production use, as nex_characters is required for full operation.**
