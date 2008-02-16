NadeAnim()
{
	hide gun;
	Turn torso to x-axis <-10> speed <20>*NADE_SPEED;
	Turn torso to y-axis <-20> speed <40>*NADE_SPEED;
	turn luparm to x-axis <0> speed <40>*NADE_SPEED;
	Turn luparm to y-axis <-20> speed <40>*NADE_SPEED;
	Turn luparm to z-axis <-80> speed <150>*NADE_SPEED;

	Turn lloarm to x-axis <-20> speed <40>*NADE_SPEED;
	Turn lloarm to y-axis <0> speed <40>*NADE_SPEED;
	Turn lloarm to z-axis <0> speed <40>*NADE_SPEED;

	Turn ruparm to x-axis <20> speed<40>*NADE_SPEED;
	Turn ruparm to y-axis <0> speed<40>*NADE_SPEED;
	Turn ruparm to z-axis <55> speed <100>*NADE_SPEED;

	Turn rloarm to x-axis <-35> speed <150>*NADE_SPEED;
	turn rloarm to y-axis <0> speed <150>*NADE_SPEED;
	Turn rloarm to z-axis <85> speed <150>*NADE_SPEED;

	Turn rthigh to x-axis <20> speed <40>*NADE_SPEED;
	Turn rthigh to y-axis <0> speed <40>*NADE_SPEED;
	Turn rthigh to z-axis <0> speed <40>*NADE_SPEED;

	Turn rleg to x-axis <45> speed <80>*NADE_SPEED;
	Turn rleg to y-axis <0> speed <80>*NADE_SPEED;
	Turn rleg to z-axis <0> speed <80>*NADE_SPEED;

	Turn lthigh to x-axis <-65> speed <120>*NADE_SPEED;
	Turn lthigh to y-axis <0> speed <120>*NADE_SPEED;
	Turn lthigh to z-axis <0> speed <120>*NADE_SPEED;

	Turn lleg to x-axis <50> speed <90>*NADE_SPEED;
	Turn lleg to y-axis <0> speed <90>*NADE_SPEED;
	Turn lleg to z-axis <0> speed <90>*NADE_SPEED; //end of frame one

wait-for-turn lleg around x-axis;
	Turn torso to x-axis <0> speed <50>*NADE_SPEED;//start of frame two
	Turn luparm to y-axis <50> speed <120>*NADE_SPEED;
	Turn luparm to z-axis <-55> speed <120>*NADE_SPEED;
	Turn lloarm to x-axis <-40> speed <40>*NADE_SPEED;
	Turn ruparm to x-axis <60> speed <120>*NADE_SPEED;
	Turn ruparm to y-axis <35> speed <120>*NADE_SPEED;
	Turn ruparm to z-axis <70> speed <120>*NADE_SPEED;
	turn rloarm to y-axis <15> speed <120>*NADE_SPEED;
	Turn rthigh to x-axis <10> speed <120>*NADE_SPEED;
	Turn rleg to x-axis <25> speed <120>*NADE_SPEED;
	Turn lthigh to x-axis <0> speed <120>*NADE_SPEED;
	Turn lleg to x-axis <0> speed <120>*NADE_SPEED; //end of frame two

wait-for-turn lleg around x-axis;
	Turn torso to y-axis <0> speed <20>*NADE_SPEED;//start of frame three (resetting model)
	Turn luparm to z-axis <0> speed <100>*NADE_SPEED;
	Turn lloarm to x-axis <0> speed <100>*NADE_SPEED;
	Turn ruparm to y-axis <0> speed <100>*NADE_SPEED;
	Turn ruparm to z-axis <0> speed <100>*NADE_SPEED;
	Turn rloarm to z-axis <0> speed <100>*NADE_SPEED;
	Turn rthigh to x-axis <0> speed <120>*NADE_SPEED;
	Turn rleg to x-axis <0> speed <120>*NADE_SPEED;
	move pelvis to y-axis [0] speed <200>*NADE_SPEED;
wait-for-turn rleg around x-axis;
}