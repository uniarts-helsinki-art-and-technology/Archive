import com.dhchoi.CountdownTimer;
import com.dhchoi.CountdownTimerService;

final long SECOND_IN_MILLIS = 1000;
final long HOUR_IN_MILLIS = 36000000;

CountdownTimer timer;
int elapsedTime = 0;

String timeText = "";
final int timeTextX = 15, timeTextY = 120;  // upper left corner of displayed text
color timeTextColor = color(255, 0, 0);  // color of text (red: stopped, green: running)
int timeTextFrames = 0, timeTextSeconds = 0, timeTextMinutes = 0; // the seconds and minutes to be displayed

final int framesPerSecondVideo = 24;

void updateTimeText() {

  timeTextSeconds = (elapsedTime ) % 60;
  timeTextMinutes = (elapsedTime ) / 60;
  timeText = nf(timeTextMinutes, 2) + ':' + nf(timeTextSeconds, 2) ;
}

// this is called once per second when the timer is running
void onTickEvent(CountdownTimer t, long timeLeftUntilFinish) {
  ++elapsedTime;
  updateTimeText();
}

// this will be called after the timer finishes running for an hour 
void onFinishEvent(CountdownTimer t) {
  exit();
}
