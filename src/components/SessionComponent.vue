<template>
  <div>
    <v-dialog v-model="dialog" max-width="500px">
      <v-card>
        <v-card-title>
          <span class="headline">Edit time</span>
        </v-card-title>

        <v-card-text>
          <v-container grid-list-md>
            <v-layout wrap>
              <v-flex xs12 sm6 md4>
                <v-text-field v-model="timeToEdit" label="adjust the time (do not cheat ;)"/>
              </v-flex>
            </v-layout>
          </v-container>
        </v-card-text>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" flat @click="dialog = false">Cancel</v-btn>
          <v-btn color="blue darken-1" flat @click="saveChanges">Save</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-data-table :headers="headers" :items="times" hide-actions>
      <template v-slot:items="props" style="color: red">
        <td class="text-xs-left">{{ props.index + 1 }}</td>
        <td class="text-xs-left">{{ ToTimeString(props.item.value) }}</td>
        <td class="justify-center layout px-0">
          <v-icon small class="mr-2" @click="editTime(props.index)">edit</v-icon>
          <v-icon small @click="deleteTime(props.index)">delete</v-icon>
        </td>
      </template>
      <template v-slot:no-data> 
        <v-alert style="height: 10px" :value="true" color="info" icon="warning">Solve some puzzles</v-alert>
      </template>
    </v-data-table>
    <div style="margin: 4px;">Average {{ ToTimeString(average) }}</div>
  </div>
</template>

<script lang="ts">
import { Component, Prop, Vue } from "vue-property-decorator";
import { Stopwatch } from "ts-stopwatch";
import moment from "moment";
import { ScrambleTime } from "@/ScrambleTime";

class Header {
  public text: string = "";
  public sortable: boolean = false;
}

@Component
export default class SessionComponent extends Vue {
  @Prop({ default: [] }) public times!: ScrambleTime[];

  public dialog: boolean = false;
  public timeToEdit: number = 0;
  public indexToEdit: number = 0;
  public headers: Header[] = [
    { text: "Solve", sortable: false },
    { text: "Time", sortable: false },
    { text: "Actions", sortable: false }
  ];

  get average() {
    let all: number = 0;
    if (this.times.length === 0) {
      return 0;
    }
    for (const time of this.times) {
      all += time.value;
    }

    if (this.times.length > 2) {
      const values = this.times.map(x => x.value);
      all -= Math.min(...values);
      all -= Math.max(...values);
      return all / (this.times.length - 2);
    }

    return all / this.times.length;
  }

  public editTime(index: number): void {
    console.log("Index to edit =  " + index);

    this.indexToEdit = index;
    this.timeToEdit = this.times[index].value;
    console.log("time to edit =  " + this.timeToEdit);
    this.dialog = true;
  }

  public ToTimeString(time: number) {
    const date = moment(new Date(time));
    return date.format("mm:ss.SSS");
  }

  public deleteTime(index: number) {
    if (confirm("Are you sure you want to delete this time?"))
      this.times.splice(index, 1);
  }

  public saveChanges() {
    const time = new ScrambleTime(this.timeToEdit - new Date(0).valueOf());
    console.log("edited time: " + time.value);
    this.times.splice(this.indexToEdit, 1, time);
    this.dialog = false;
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
