<template>
  <div>
    <v-data-table :headers="headers" :items="times" hide-actions>
      <template v-slot:items="props" style="color: red" >
        <td class="text-xs-left">{{ props.index + 1 }}</td>
        <td class="text-xs-left">{{ ToTimeString(props.item) }}</td>
        <td class="justify-center layout px-0">
          <v-icon small class="mr-2" @click="editItem(props.item)">edit</v-icon>
          <v-icon small @click="deleteItem(props.item)">delete</v-icon>
        </td>
      </template>
      <template v-slot:no-data>
        <v-alert style="height: 10px" :value="true" color="info" icon="warning">Solve some puzzles</v-alert>
      </template>
    </v-data-table>
    <div style="margin: 4px;">Avarage {{ ToTimeString(average) }}</div>
  </div>
</template>

<script lang="ts">
import { Component, Prop, Vue } from 'vue-property-decorator';
import { Stopwatch } from 'ts-stopwatch';
import moment from 'moment';

class Header {
  public text: string = '';
  public sortable: boolean = false;
}

@Component
export default class SessionComponent extends Vue {
  @Prop({ default: [] }) public times!: number[];

  public headers: Header[] = [
    { text: 'Number', sortable: false },
    { text: 'Time', sortable: false },
    { text: 'Actions', sortable: false },
  ];

  get average() {
    let all: number = 0;
    if (this.times.length === 0) { return 0; }
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

  public ToTimeString(time: number) {
    const date = moment(new Date(time));
    return date.format('ss:SSS');
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
