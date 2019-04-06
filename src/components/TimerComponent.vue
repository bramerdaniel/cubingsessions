<template>
  <div>
    <h1 :class="getClass">{{ timeString }}</h1>
  </div>
</template>

<script lang="ts">
import { Component, Prop, Vue, Emit } from 'vue-property-decorator';
import { Stopwatch } from 'ts-stopwatch';
import { ScrambleTime } from '../ScrambleTime';
import moment from 'moment';
import * as signalR from "@aspnet/signalr";

const PreparingTimeout: number = 400;

enum TimerStates {
  Ready = 'Ready',
  Preparing = 'Preparing',
  PreparingCompleted = 'PreparingCompleted',
  Runing = 'Runing',
  Stopped = 'Stopped',
}

const space: number = 32;

@Component
export default class TimerComponent extends Vue {

  get timeFormat() {
    const date = new Date(this.time);
    if (this.timerState === TimerStates.Preparing || this.timerState === TimerStates.PreparingCompleted)
      return 's.S';

    const minFormat = date.getMinutes() > 0 ? 'm:' : '';
    return minFormat + this.timerState === TimerStates.Runing
      ? 's.S'
      : 'ss.SSS';
  }

  get timeString() {
    return moment(this.time).format(this.timeFormat);
  }

  get getClass() {
    switch (this.timerState) {
      case TimerStates.Preparing:
        return 'preparing';
      case TimerStates.PreparingCompleted:
        return 'preparingCompleted';
      case TimerStates.Runing:
        return 'running';
      default:
        return '';
    }
  }

  protected stopWatch: Stopwatch = new Stopwatch();
  protected time: number = 0;
  protected interval: number = 0;
  protected completePreparingInterval: number = 0;
  protected timerState: TimerStates = TimerStates.Ready;
  public created() {
    window.addEventListener('keyup', this.onKeyUp);
    window.addEventListener('keydown', this.onKeyDown);

    // ---------
    // Connect to our hub
    // ---------
    const connection = new signalR.HubConnectionBuilder()
      .withUrl("https://cubingsessionsapi.azurewebsites.net/notifications/")
      .configureLogging(signalR.LogLevel.Trace)
      .build();

    connection.start().catch(function(err) {
      return console.error(err.toSting());
    });

    connection.on("Bla", function(id: number) {
      console.log("Bla " + id);
    });
  }

  public onKeyUp(event: KeyboardEvent): void {
    if (event.keyCode !== space || event.repeat) { return; }

    clearTimeout(this.completePreparingInterval);

    if (this.timerState === TimerStates.PreparingCompleted) {
      this.startTimer();
    } else if (this.timerState === TimerStates.Stopped) {
      this.setState(TimerStates.Ready);
    } else if (this.timerState === TimerStates.Preparing) {
      this.setState(TimerStates.Ready);
    }
  }

  public onKeyDown(event: KeyboardEvent): void {
    if (event.keyCode !== space || event.repeat) { return; }

    if (this.timerState === TimerStates.Runing) {
      this.stopTimer();
    } else if (this.timerState === TimerStates.Ready) {
      this.time = 0;
      this.setState(TimerStates.Preparing);
      this.completePreparingInterval = setTimeout(
        this.completePreparing,
        PreparingTimeout,
      );
    }
  }

  public setState(state: TimerStates): void {
    this.timerState = state;
  }

  public completePreparing(): void {
    this.setState(TimerStates.PreparingCompleted);
  }

  public startTimer(): void {
    this.setState(TimerStates.Runing);
    this.stopWatch.start(true);
    this.interval = setInterval(this.updateTime, 100);
  }

  public stopTimer(): void {
    if (this.timerState === TimerStates.Runing) {
      this.stopWatch.stop();
      this.time = this.stopWatch.getTime();
      this.stopWatch.reset();
      clearInterval(this.interval);
      this.$emit('time-available', new ScrambleTime(this.time));
      this.setState(TimerStates.Stopped);
    }
  }

  public updateTime(): void {
    this.time = this.stopWatch.getTime();
  }
}
</script>

<style scoped>
.preparing {
  color: red;
  font-size: 410%;
}
.preparingCompleted {
  color: forestgreen;
  font-size: 410%;
}
.running {
  color: black;
  font-size: 420%;
}
.default {
  font-size: 400%;
}
</style>
