#ifndef _CHIHA_H
#define _CHIHA_H

// exhaust smoke
#define EXHAUST_SMOKE 1024+1

// definitions for wheels
#define WHEEL_SPIN		<-600>
#define WHEEL_ACCEL		<-150>

StartMoving()
{
	signal SIG_MOVE;
	bMoving = TRUE;
	spin front_wheels around x-axis speed WHEEL_SPIN accelerate WHEEL_ACCEL;
	spin rear_wheels around x-axis speed WHEEL_SPIN accelerate WHEEL_ACCEL;
	spin mid_wheels1 around x-axis speed WHEEL_SPIN*2 accelerate WHEEL_ACCEL*2;
	spin mid_wheels2 around x-axis speed WHEEL_SPIN*2 accelerate WHEEL_ACCEL*2;
	spin mid_wheels3 around x-axis speed WHEEL_SPIN*2 accelerate WHEEL_ACCEL*2;
	spin mid_wheels4 around x-axis speed WHEEL_SPIN*2 accelerate WHEEL_ACCEL*2;
	spin mid_wheels5 around x-axis speed WHEEL_SPIN*2 accelerate WHEEL_ACCEL*2;
	spin mid_wheels6 around x-axis speed WHEEL_SPIN*2 accelerate WHEEL_ACCEL*2;
	spin support_wheels1 around x-axis speed WHEEL_SPIN*6 accelerate WHEEL_ACCEL*6;
	spin support_wheels2 around x-axis speed WHEEL_SPIN*6 accelerate WHEEL_ACCEL*6;
	spin support_wheels3 around x-axis speed WHEEL_SPIN*6 accelerate WHEEL_ACCEL*6;
	emit-sfx EXHAUST_SMOKE from exhaust1;
	emit-sfx EXHAUST_SMOKE from exhaust2;
}

StopMoving()
{
	signal SIG_MOVE;
	bMoving = FALSE;
	stop-spin front_wheels around x-axis;
 	stop-spin rear_wheels around x-axis;
	stop-spin mid_wheels1 around x-axis;
	stop-spin mid_wheels2 around x-axis;
	stop-spin mid_wheels3 around x-axis;
	stop-spin mid_wheels4 around x-axis;
	stop-spin mid_wheels5 around x-axis;
	stop-spin mid_wheels6 around x-axis;
	stop-spin support_wheels1 around x-axis;
	stop-spin support_wheels2 around x-axis;
	stop-spin support_wheels3 around x-axis;
}
#endif