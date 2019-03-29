<template>
  <div>
    <h1>Cubing sessions timer</h1>
    <h1>{{ timeString }}</h1>
  </div>
</template>

<script lang="ts">
import { Component, Prop, Vue, Emit } from "vue-property-decorator";
import { Stopwatch } from "ts-stopwatch";
import moment from "moment";

@Component
export default class Timer extends Vue {
  created() {
    window.addEventListener("keyup", () => this.startTimer());
    window.addEventListener("keydown", () => this.stopTimer());
  }

  get timeString() {
    const date = moment(new Date(this.time));
    const minFormat = (date.minutes() > 0) ? "mm:" : "";
    if (this.timerIsRunning) {
      return date.format(minFormat + "ss:S");
    }
    return date.format(minFormat + "ss:SSS");
  }

  protected stopWatch: Stopwatch = new Stopwatch();
  protected time: number = 0;
  protected interval: number = 0;
  protected timerIsRunning: boolean = false;

  onKeyUp(): void {
    if (!this.timerIsRunning) {
      return;
    }

    this.startTimer();
  }

  startTimer(): void {
    if (this.timerIsRunning) return;

    this.stopWatch.reset();
    console.log("timer started");
    this.stopWatch.start();
    this.timerIsRunning = true;
    this.interval = setInterval(this.updateTime, 100);
  }

  stopTimer(): void {
    if (this.timerIsRunning) {
      this.stopWatch.stop();
      this.time = this.stopWatch.getTime();
      console.log("timer stopped at " + this.time);
      clearInterval(this.interval);
      setTimeout(() => (this.timerIsRunning = false), 100);
      this.$emit("time-available", this.time);
    }
  }

  updateTime(): void {
    this.time = this.stopWatch.getTime();
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>




</style>
