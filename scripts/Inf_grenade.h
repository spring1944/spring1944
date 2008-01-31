NadeAnim()
{
	hide gun;
	Turn torso to x-axis <-10> speed <80>;
	Turn torso to y-axis <-20> speed <160>;
	turn luparm to x-axis <0> speed <160>;
	Turn luparm to y-axis <-20> speed <160>;
	Turn luparm to z-axis <-80> speed <600>;

	Turn lloarm to x-axis <-20> speed <160>;
	Turn lloarm to y-axis <0> speed <160>;
	Turn lloarm to z-axis <0> speed <160>;

	Turn ruparm to x-axis <20> speed<160>;
	Turn ruparm to y-axis <0> speed<160>;
	Turn ruparm to z-axis <55> speed <400>;

	Turn rloarm to x-axis <-35> speed <600>;
	turn rloarm to y-axis <0> speed <600>;
	Turn rloarm to z-axis <85> speed <600>;

	Turn rthigh to x-axis <20> speed <160>;
	Turn rthigh to y-axis <0> speed <160>;
	Turn rthigh to z-axis <0> speed <160>;

	Turn rleg to x-axis <45> speed <320>;
	Turn rleg to y-axis <0> speed <320>;
	Turn rleg to z-axis <0> speed <320>;

	Turn lthigh to x-axis <-65> speed <480>;
	Turn lthigh to y-axis <0> speed <480>;
	Turn lthigh to z-axis <0> speed <480>;

	Turn lleg to x-axis <50> speed <360>;
	Turn lleg to y-axis <0> speed <360>;
	Turn lleg to z-axis <0> speed <360>; //end of frame one

wait-for-turn lleg around x-axis;
	Turn torso to x-axis <0> speed <200>;//start of frame two
	Turn luparm to y-axis <50> speed <480>;
	Turn luparm to z-axis <-55> speed <480>;
	Turn lloarm to x-axis <-40> speed <160>;
	Turn ruparm to x-axis <60> speed <480>;
	Turn ruparm to y-axis <35> speed <480>;
	Turn ruparm to z-axis <70> speed <480>;
	turn rloarm to y-axis <15> speed <480>;
	Turn rthigh to x-axis <10> speed <480>;
	Turn rleg to x-axis <25> speed <480>;
	Turn lthigh to x-axis <0> speed <480>;
	Turn lleg to x-axis <0> speed <480>; //end of frame two

wait-for-turn lleg around x-axis;
	Turn torso to y-axis <0> speed <80>;//start of frame three (resetting model)
	Turn luparm to z-axis <0> speed <400>;
	Turn lloarm to x-axis <0> speed <400>;
	Turn ruparm to y-axis <0> speed <400>;
	Turn ruparm to z-axis <0> speed <400>;
	Turn rloarm to z-axis <0> speed <400>;
	Turn rthigh to x-axis <0> speed <480>;
	Turn rleg to x-axis <0> speed <480>;
	move pelvis to y-axis [0] speed <800>;
wait-for-turn rleg around x-axis;
}