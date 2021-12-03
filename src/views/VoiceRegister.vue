<template>
  <v-container class="mt-10 pa-10">
    <v-row justify="center">
      <v-col cols="6">
        <v-form @submit.prevent="">
          <v-text-field
            v-model="curp_register"
            :rules="[rules.required, rules.validator]"
            @input="upper()"
            counter="18"
            validate-on-blur
            maxlength="18"
            label="Ingrese la CURP"
          >
          </v-text-field>
          <v-file-input
            class="mt-5"
            :accept="'audio/wav'"
            label="Seleccione tres audios en formato wav"
            clear-icon="mdi-close-circle"
            cleareable
            dense
            multiple
            small-chips
            show-size
            v-model="files"
            type="file"
          ></v-file-input>
          <v-btn @click="send()" color="indigo" class="ml-4" :loading="loading">Enviar</v-btn>
        </v-form>
      </v-col>
    </v-row>
    <v-row justify="center"> </v-row>
  </v-container>
</template>
<script>
import axios from "axios";
import Swal from 'sweetalert2';
import config from '../config/config';
export default {
  data() {
    return {
      files: null,
      curp_register: '',
      loading: false,
      formData: new FormData(),
      curp_rule: RegExp(
        "^[A-Z]{1}[AEIOU]{1}[A-Z]{2}[0-9]{2}(0[1-9]|1[0-2])(0[1-9]|1[0-9]|2[0-9]|3[0-1])[HM]{1}(AS|BC|BS|CC|CS|CH|CL|CM|DF|DG|GT|GR|HG|JC|MC|MN|MS|NT|NL|OC|PL|QT|QR|SP|SL|SR|TC|TS|TL|VZ|YN|ZS|NE)[B-DF-HJ-NP-TV-Z]{3}[0-9A-Z]{1}[0-9]{1}$"
      ),
      rules: {
        required: (v) => !!v || "Obligatorio",
        validator: (v) => this.curp_rule.test(v) || "Revisa la CURP",
      },
    };
  },
  methods: {
    async send() {
      this.loading = true;
      if(!this.files || this.files.length == 0 || this.curp_register.length == 0 || !this.curp_rule.test(this.curp_register)) {
        return Swal.fire({
          title: 'Revisa la información',
          text: 'Tienes que seleccionar 3 audios e ingresar la CURP correctamente.',
          icon: 'info'
        })
        .then(() => setTimeout(() => this.loading = false, 300));
      }
      try {
        this.formData.append("record1", this.files[0], this.files[0].name);
        this.formData.append("record2", this.files[1], this.files[1].name);
        this.formData.append("record3", this.files[2], this.files[2].name);
        this.formData.append("curp", this.curp_register);
        let res = await axios.post(
          `${config.api}/voicePrint/save`,
          this.formData,
          {},
          {
            headers: {
              "Content-Type": "multipart/form-data",
            },
          }
        );
        if(res.data.r){
          return Swal.fire({
            title: '¡Hecho!',
            text: res.data.messages,
            icon: 'success',
          })
          .then(() => setTimeout(() => this.loading = false, 300));
        }
      } catch (e) {
        console.log(e);
        this.loading = false;
      }
    },
    upper() {
      this.curp_register = this.curp_register.toUpperCase();
    },
  },
};
</script>