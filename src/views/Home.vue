<template>
  <div class="home">
    <h1>Cubing sessions timer</h1>
    <Timer @time-available="onTimeAvailable"/>
    <SessionComponent class="session" :times="times"/>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from "vue-property-decorator";
import Timer from "@/components/Timer.vue";
import SessionComponent from "@/components/SessionComponent.vue";

@Component({
  components: {
    Timer,
    SessionComponent
  }
})
export default class Home extends Vue {
  constructor() {
    super();
  }

  times: Array<number> = [];

  onTimeAvailable(data: number): void {
    console.log("Got time " + data);
     this.times.push(data);
  }
}
</script>


<style scoped>
#app {
  display: grid;
  min-height: 100vh;
  justify-content: center;
}
.session {
  margin: auto 44% ;
  width: 20vw;
  
}
</style>