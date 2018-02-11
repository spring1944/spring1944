-- Let's add the fixed factions. There are several widgets that already assumed
-- these factions exist, and are sorted in that way. So better adding them like
-- that for the time being.
local sidedata = {
	{
	name = "Random Team (GM)",
	startUnit = "GMToolbox",
	wiki_title = "Random team",
	wiki_description = "A random team",
	},
	{
	name = "GER",
	startUnit = "GERHQBunker",
	wiki_title = "Nazi Germany",
	wiki_desc = [[## Introduction

After Adolf Hitler's rise to power, the Nazi Germany started imperialist policy, seizing first Austria and Czechoslovakia in 1938 and 1939, without international opposition. However, the invasion of Poland in 1939 triggered the WWII.

## Strengths

Despite their eventual loss of the war, the armed forces of Germany were armed with many highly advanced tools. The more famous tools in their possessions were undoubtedly their tanks and jet aircraft, both of which the Allies were never really able to fully counter during the conflict.

Germany is able to field more heavily armed and armoured fighting vehicles than their enemies; the Tiger, Panther and Tiger II have no real battlefield counterparts and are extremely dangerous, a fact Allied forces learned quickly during and after the Normandy landings and the liberation of France. For the Tiger and Tiger II inparticular, the only consistent way to deal with their presence during a battle was air support in the form of rocket-firing Mustangs and Typhoons that could attack the heavy tanks from the relative safety of the air. On the ground, British and American tanks were woefully undergunned and underprotected, and suffered huge losses in direct confrontations with heavy German tanks.

Germany's aircraft can also be quite spectacular. Particularly, the Fw 190A-8 superiority fighter is the most heavily armed combat aircraft available, armed with four 20mm cannons and two 15mm cannons, its damage projection far outweighs its main rivals. The Me 262, the first jet aircraft to see widespread service, is even more heavily armed, with four 30mm cannons and racks of air-to-air unguided rockets and speeds that no Allied aircraft can match.

## Weakness

For all of its strength however, German forces have several underlying weaknesses that are easily exploited by its enemies. By 1944, Germany was ruined economically -- most of its industry by this time was utterly destroyed by round-the-clock bombing from Britain and France. Perhaps worst of all, it suffered catastrophic fuel shortages that grounded many of its planes and impeded deployment of many of its tanks. Almost as bad were its manpower shortages; after 5 years of constant warfare much of Germany's available manpower, specifically men between the ages of 16-45, were heavily depleted -- a popular example of the hardships this placed on the German war machine is the fact that production of aircraft and tanks was its highest during 1944, but Germany simply did not have the fuel or the manpower to use them.

This affected the fighting capabilities of the Wehrmacht's frontline units as well. By 1944 much of Wehrmacht combat units were composed of foreign conscripts, POWs, the very young and the very old, a stark contrast to years earlier when the Wehrmacht embodied the idea of the most professional and well-trained army.]],
	},
	{
	name = "GBR",
	startUnit = "GBRHQ",
	wiki_title = "Great Britain",
	wiki_desc = [[## Introduction

Great Britain led Allied efforts in almost every global military theatre of the WWII. Despite the initial failed campaign along Europe, Great Britain slowed, or even stop the Axis advances in many fronts, meanwhile a great military industry was developed.

## Strengths

The British field some of the best infantry in the game, which greatly helps them gain land in the beginning. The HQ squad is rather small, but it is the only HQ squad to provide with light machine guns and is the fastest way to get infantry ifre support this early on.

Lots of tools the british have empasize this, like a rather cheap armored infantry transport and glider infantry. In most situations, when you see your enemy has a similar amout of infantry, expect a rather swift victory.

The british have some good anti-tank aircraft as well, making for very risky combo's, allowing you to play quickly, not giving others time to understand what you are doing and where you're gonna hit next. 

## Weakness

British weakness lies in armor. Not to say that britsh armor is bad, but it's either overpriced, or pretty easy to destroy. In the end, you're more likely to use tank destroyers, as the heavier versions become very efficient and easy to use overall.

One other rather annoying aspect of the GBR faction is the artillery. Despite having the longest ranged guns in the game, they deal several times less damage, making them at most infantry support weapons. Using them to destroy buildings will take longer than usual if you don't have any sight of the location.]],
	},
	{
	name = "RUS",
	startUnit = "RUSCommissar",
	wiki_title = "Union of Soviet Socialist Republics",
	wiki_desc = [[## Introduction

Soviet union signed a non-aggression pact with Germany before the invasion of Poland in 1939, and in fact they honoured such pact up to the begin of the Nazi Germany hostilities. Unfortunately, Joseph Stalin was confident that the total Allied war machine would eventually stop Germany, deploying an insufficient military power which sistematically lost territory. Soviet Union finally stop the German forces advance at 30 kilometers from Moscow, finally taking the initiative.

## Strengths

Fast and cheap, this is as close to a zerg as you're gonna get. You can undeploy any gun, including AA guns and late game raiding is something done almost exclusevly by soviets due to the fastest tank in the game being also one of the cheapest. Cheap infantry means a loss is not such a big deal, since more can be made really fast. Soviet weapons are known to be the most accurate ones, especially anti-tank weapons, giving a much more reliable solution to enemy armor then other factions. Soviets also possess the cheapest buildpower, at about 330 per constructor, which can also cloak to hide from enmy units and infiltrate enemy bases, possible making mines, barracks and other nasty suprises. When soviets get raided, they don't rush their AT guns to the storages - they rush the storages to the AT guns. As the faction with the only mobile storages in the game, you can never truly know where you should attack to make it hurt. And if you don't catch a soviet by suprise, the supply truck will just outrun most invaders.

## Weakness

While having speed and good aim helps, soviet guns are generally weaker and not as well armored as enemy equivelents. Infantry captures flags at a slower rate (about 10 times slower, meaning a squad of soviet infantry will capture flags as fast as a single rifleman). This is compensated by having commisars capture 10 times as fast as normal infantry, forcing you to constantly make a decicion: to build, or to expand. Soviets are always slower to get tanks, as they do not start with normal builders like others, but rather basic builders and making a barracks before able to do anything else really slows the soviet start. If soviets chose to be mobile, undeployed trucks are vulnerable to fighters and intercepters, as they can start attacking before entering the ranges of your AA, easily popping the ammo supply.]],
	},
	{
	name = "US",
	startUnit = "USHQ",
	wiki_title = "United States of America",
	wiki_desc = [[## Introduction

United States of America kept unaware of the WWII until the attack of Pearl Harbor, carried out by Japan forces. After that, United States fight back the Axis power, first in Pacific against Japan, and later in North Africa, Italy, and the rest of Europe.

## Strengths

The US focus on offence, as most units are equipped to deal damage fast enough before something is able to kill them. Many, many tactics can be employed by the US, as they have a lot of options by midgame and switching tech doesn't seem to throw US back all that much.

## Weakness

While offence is good, there are times when you need to protect yourself from invading forces. Unfortunatly, US don't really defend all that well. Often a defending US player will retreat to get more breathing room, while other factions can hold any sort of ground comfortably. Shorter ranged units have this behaviour in general.

While US have a solid midgame and a very aggresive start with powerful infantry and much better Shermans, they lose a lot of that momentum once other factions get to catch up in the tech tree, making Shermans not too good in general.]],
	},
	{
	name = "ITA",
	startUnit = "ITAHQ",
	wiki_title = "Italy",
	wiki_desc = [[## Introduction

Italy aligned with the Axis power, introducing the North Africa theater. However, the North Africa campaign was truncated by Great Britain forces, requiring indeed German reinforcements, commanded by Romel. Unfortunately, Romel did not enjoyed a good supplies line due to the terrain itself, and the invasion of the Soviet Union, which was demanding a large ammount of supplies.

## Strengths

The strength of the Italian army lies in the advanced infantry core. Much like the British, Italians tend to field underpreforming tanks to support a tipically larger and more powerful infantry base. The advanced squads are provided with a rather cheap barracks upgrade and at a lower then average cost.

Other then a strong infantry core, Italy can field some rather unusual support weaponry to aid their infantry force, such as mobile AT platforms and gun trucks, as well as somewhat cheap heavy tank destroyers.

## Weakness

From start to about the beginning of the tank phase, Italy has almost nothing to offer in the anti-armor department, leaving the italian player either surviving until he can field a decent weapon, or being over-aggressive with his infantry. Since there is no AT squad in the barracks selection, the italian player solely relies on the toy grenades most of his infantry have, as they do significantly less damage then the grenades of other factions. The nightmare contines with the starting AT guns, as they offer only mild protection with use limited to the very early game.

Late game the situation changes, as Italy fields much better armored tank destroyers, but lack a well armed tank themselves, leaving them highly dependent on infantry even in the later stages of the game.]],
	},
	{
	name = "JPN",
	startUnit = "JPNHQ",
	wiki_title = "Japan",
	wiki_desc = [[## Introduction

The economic sanctions of United States, due to the military aggressions carried out by Japan forces along Asia and Pacific sea, lead the imperium to start the offensive against US. Japan had a clear advantage before the battle of Midway, where Imperial Japan Navy lost a significant ammount of military resources, including several air carriers. After that, imperial forces threatened US, enforcing them to fight along heavily fortified islands.

## Strengths

Japan is great when it comes to hit and run tactics. Like the soviets, they are very zerg-like in nature and have an interesting balance system to show this. Like the soviets, their tanks are cheaper than average, but the difference being that they are significantly cheaper and trade almost everything a tank can bring to the field in favor of a bigger gun.

Japan infantry may not be the cheapest, but they are most relient on indirect firepower and outside support, making them the only actual infantry that is not quite fit for fair combat.

## Weakness

Although they have the cheapest armor in the game, it's also the weakest. Most of the tanks a Japan player can field don't qualify for medium class.

Japan infantry are also the least useful in direct combat, as they heavily rely on knee mortars and other possible support weapons.]],
	},
	{
	name = "SWE",
	startUnit = "SWEHQ",
	wiki_title = "Sweden",
	wiki_desc = [[## Introduction

.

## Strengths

.

## Weakness

.]],
	},
	{
	name = "HUN",
	startUnit = "HUNHQ",
	wiki_title = "Hungary",
	wiki_desc = [[## Introduction

.

## Strengths

.

## Weakness

.]],
    }
}

-- Let's append more factions as an extension
Spring.Log('sidedata', 'info', "Loading sides data...")
local SideFiles = VFS.DirList("gamedata/side_data", "*.lua")
Spring.Log('sidedata', 'info', "Found "..#SideFiles.." tables")
-- then add their contents to the main table
for _, SideFile in pairs(SideFiles) do
	Spring.Log('sidedata', 'info', " - Processing "..SideFile)
	local tmpTable = VFS.Include(SideFile)
	if tmpTable then
		sidedata[#sidedata + 1] = tmpTable
		Spring.Log('sidedata', 'info', " -- Added ".. tmpTable.name .." faction")
		tmpTable = nil
	end
end

return sidedata
