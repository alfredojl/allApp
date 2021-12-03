<template>
  <v-container class="mt-10 pa-10">
    <v-row justify="center">
      <v-col cols="6">
        <v-form @submit.prevent="">
          <v-text-field
            v-model="curp_recognition"
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
            label="Seleccione un audio en formato wav"
            clear-icon="mdi-close-circle"
            cleareable
            dense
            show-size
            v-model="file"
            type="file"
          ></v-file-input>
          <v-btn @click="send()" color="indigo" class="ml-4" :loading="loading"
            >Enviar</v-btn
          >
        </v-form>
      </v-col>
    </v-row>
    <v-row justify="center">
      <h2>{{ message }}</h2>
    </v-row>
  </v-container>
</template>

<script>
import axios from "axios";
import Swal from "sweetalert2";
import config from '../config/config';
export default {
  data() {
    return {
      file: null,
      loading: false,
      message: null,
      formData: new FormData(),
      curp_recognition: '',
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
      if(!this.file || this.curp_recognition.lenght == 0 || !this.curp_rule.test(this.curp_recognition))
        return Swal.fire({
          title: 'Revisa la información',
          text: 'Tienes que seleccionar un audio e ingresar la CURP correctamente.',
          icon: 'info'
        })
        .then(() => setTimeout(() => this.loading = false, 300))
      try {
        this.formData.append("record", this.file, this.file.name);
        this.formData.append("curp", this.curp_recognition);
        let res = await axios.post(
          `${config.api}/voicePrint/validate`,
          this.formData,
          {},
          {
            headers: {
              "Content-Type": "multipart/form-data",
            },
          }
        );
        if (res.data.r)
          return Swal.fire({
            title: "¡Éxito!",
            text: `${res.data.message}. Similitud: ${parseFloat(res.data.similitud).toFixed(4)*100} %. Lista: ${res.data.lista.join(', ')}.`,
            icon: "success",
          }).then(() => setTimeout(() => this.loading = false, 300));
        if (!res.data.r)
          return Swal.fire({
            title: "¡Oops!",
            text: `${res.data.message}. Similitudes: ${res.data.lista.join(
              ", "
            )}.`,
            icon: "warning",
          }).then(() => setTimeout(() => this.loading = false, 300));
      } catch (e) {
        console.log(e);
      }
    },
    upper() {
      this.curp_recognition = this.curp_recognition.toUpperCase();
    },
  },
};
</script>