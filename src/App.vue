<template>
  <v-app id="inspire">
    <v-navigation-drawer v-model="drawerRight" fixed right clipped app>
      <v-list dense>
        <v-list-tile @click.stop="right = !right">
          <v-list-tile-action>
            <v-icon>exit_to_app</v-icon>
          </v-list-tile-action>
          <v-list-tile-content>
            <v-list-tile-title>Here are some settings</v-list-tile-title>
          </v-list-tile-content>
        </v-list-tile> 
      </v-list>
    </v-navigation-drawer> 

    <v-navigation-drawer v-model="drawer" fixed app clipped>
      <v-list dense>
        <v-list-tile @click.stop="left = !left">
          <v-list-tile-action>
            <v-icon>exit_to_app</v-icon>
          </v-list-tile-action>
          <v-list-tile-content>
            <v-list-tile-title>Times and statistic</v-list-tile-title>
          </v-list-tile-content>
        </v-list-tile>
        <v-list-tile @click.stop="clearTimes">
          <v-list-tile-action>
            <v-icon>clear</v-icon>
          </v-list-tile-action>
          <v-list-tile-content>
            <v-list-tile-title>Clear times</v-list-tile-title>
          </v-list-tile-content>
        </v-list-tile>
        <session-component class="session" :times="times"/>
      </v-list>
    </v-navigation-drawer>

    <v-toolbar color="blue-grey" dark fixed app clipped-right>
      <!--v-toolbar-side-icon @click.stop="drawer = !drawer"></v-toolbar-side-icon-->
      <v-toolbar-title>Cubing sessions</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-toolbar-side-icon @click.stop="drawerRight = !drawerRight"/>
    </v-toolbar>

    <v-navigation-drawer v-model="left" temporary fixed/>
    <v-content>
      <v-container fluid fill-height>
        <v-layout justify-center align-center>
          <v-flex shrink>
            <v-tooltip right>
              <template v-slot:activator="{ on }">
                <timer-component @time-available="onTimeAvailable"/>
              </template>
              <span>Source</span>
            </v-tooltip>
            <v-tooltip right>
              <template v-slot:activator="{ on }">
                <v-btn
                  icon
                  large
                  href="https://codepen.io/johnjleider/pen/KQrPKJ"
                  target="_blank"
                  v-on="on"
                >
                  <v-icon large>mdi-codepen</v-icon>
                </v-btn>
              </template>
              <span>Codepen</span>
            </v-tooltip>
          </v-flex>
        </v-layout>
      </v-container>
    </v-content>
    <v-navigation-drawer v-model="right" right temporary fixed></v-navigation-drawer>
    <v-footer color="blue-grey" class="white--text" app>
      <span>cubing sessions</span>
      <v-spacer></v-spacer>
      <span>&copy; 2019</span>
    </v-footer>
  </v-app>
</template>



<script lang="ts">
import { Component, Vue, Prop } from "vue-property-decorator";
import TimerComponent from "@/components/TimerComponent.vue";
import SessionComponent from "@/components/SessionComponent.vue";
import Vuetify from "vuetify/types";
import { ScrambleTime } from "@/ScrambleTime";

@Component({
  components: {
    TimerComponent,
    SessionComponent
  }
})

export default class App extends Vue {
  public times: ScrambleTime[] = [];
  public drawer: boolean = true;
  public drawerRight: boolean = false;
  public right: boolean = false;
  public left: boolean = false;

  // @Prop({ default: "" }) source!: string;

  public clearTimes() {
    if (confirm("Are you sure you want to delete all times?"))
      this.times.splice(0);
  }

  public onTimeAvailable(data: ScrambleTime): void {
    this.times.unshift(data);
  }
}

// export default {
//   name: 'App',
//   components: {
//     HelloWorld,
//     TimerComponent,
//     SessionComponent
//   },
//   data:() => ({
//       drawer: null,
//       drawerRight: null,
//       right: false,
//       left: false
//     }),
//       props: {
//       source: String
//     }
// }
</script>
