<template>
  <div>
    <!-- <h1>Session times</h1> -->
    <table class="table">
      <thead>
        <tr>
          <td style="width: 30%">Number</td>
          <td style="width: 70%">Time</td>
        </tr>
      </thead>
      <tbody> 
        <template v-if="times.length === 0">
          <tr>
            <td class="empty" colspan="3">No times to display</td>
          </tr>
        </template>
        <template v-else>
          <tr v-for="(time, index) in times" :key="time">
            <td>{{index + 1}}</td>
            <td>{{ToTimeString(time)}}</td>
          </tr>
        </template>
      </tbody>
    </table>
    <a @click="times.splice(0, times.length)"  href=""  tabIndex="-1">Clear times</a>
    <div style="margin: 4px;">Avarage {{ ToTimeString(average) }}</div>
  </div>
</template>

<script lang="ts">
import { Component, Prop, Vue } from "vue-property-decorator";
import { Stopwatch } from "ts-stopwatch";
import moment from "moment";

@Component
export default class SessionComponent extends Vue {
  @Prop({ default: [] }) times!: Array<number>;

  get average() {
    let all: number = 0;
    if (this.times.length === 0) return 0;
    for (const time of this.times) {
      all += time;
    }

    if (this.times.length > 2) {
      all -= Math.min(...this.times);
      all -= Math.max(...this.times);
      return all / (this.times.length - 2);
    }

    return all / this.times.length;
  }

  ToTimeString(time: number) {
    const date = moment(new Date(time));
    return date.format("ss:SSS");
  }
}
</script>

<style scoped>
.table {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
}
.table td {
  padding: 0.3rem;
}
.table thead {
  font-weight: bold;
  text-transform: uppercase;
}
</style>
