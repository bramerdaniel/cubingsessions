<template>
  <div>
    <h1 :class="getClass">{{ timeString }}</h1>
  </div>
</template>

<script lang="ts">
import { Component, Prop, Vue, Emit } from "vue-property-decorator";
import { Stopwatch } from "ts-stopwatch";
import moment from "moment";

const PreparingTimeput: number = 500;

enum TimerStates {
  Ready = "Ready",
  Preparing = "Preparing",
  PreparingCompleted = "PreparingCompleted",
  Runing = "Runing",
  Stopped = "Stopped"
}

const space: number = 32;

@Component
export default class TimerComponent extends Vue {
  created() {
    window.addEventListener("keyup", this.onKeyUp);
    window.addEventListener("keydown", this.onKeyDown);
  }

  get timeFormat() {
    const date = new Date(this.time);
    const minFormat = date.getMinutes() > 0 ? "m:" : "";
    return minFormat + this.timerState === TimerStates.Runing
      ? "s.S"
      : "ss.SSS";
  }

  get timeString() {
    return moment(this.time).format(this.timeFormat);
  }

  get getClass() {
    switch (this.timerState) {
      case TimerStates.Preparing:
        return "preparing";
      case TimerStates.PreparingCompleted:
        return "preparingCompleted";
      case TimerStates.Runing:
        return "running";
      default:
        return "";
    }
  }

  protected stopWatch: Stopwatch = new Stopwatch();
  protected time: number = 0;
  protected interval: number = 0;
  protected completePreparingInterval: number = 0;
  protected timerState: TimerStates = TimerStates.Ready;

  onKeyUp(event: KeyboardEvent): void {
    if (event.keyCode !== space || event.repeat) return;

    console.log("on space key up");
    clearTimeout(this.completePreparingInterval);

    if (this.timerState === TimerStates.PreparingCompleted) {
      this.startTimer();
    } else if (this.timerState === TimerStates.Stopped) {
      this.setState(TimerStates.Ready);
    } else if (this.timerState === TimerStates.Preparing) {
      this.setState(TimerStates.Ready);
    }
  }

  onKeyDown(event: KeyboardEvent): void {
    if (event.keyCode !== space || event.repeat) return;

    console.log("on space key down");
    if (this.timerState === TimerStates.Runing) {
      this.stopTimer();
    } else if (this.timerState === TimerStates.Ready) {
      this.time = 0;
      this.setState(TimerStates.Preparing);
      this.completePreparingInterval = setTimeout(
        this.completePreparing,
        PreparingTimeput
      );
    }
  }

  setState(state: TimerStates): void {
    console.log(this.timerState + " => " + state);
    this.timerState = state;
  }

  completePreparing(): void {
    this.setState(TimerStates.PreparingCompleted);
  }

  startTimer(): void {
    this.setState(TimerStates.Runing);
    this.stopWatch.start();
    this.interval = setInterval(this.updateTime, 100);
  }

  stopTimer(): void {
    if (this.timerState === TimerStates.Runing) {
      this.stopWatch.stop();
      this.time = this.stopWatch.getTime();
      this.stopWatch.reset();
      clearInterval(this.interval);
      this.$emit("time-available", this.time);
      this.setState(TimerStates.Stopped);
    }
  }

  updateTime(): void {
    this.time = this.stopWatch.getTime();
  }
}
</script>

<style scoped>
.preparing {
  color: red;
  font-size: 210%;
}
.preparingCompleted {
  color: forestgreen;
  font-size: 210%;
}
.running {
  color: black;
  font-size: 400%;
}
</style>
