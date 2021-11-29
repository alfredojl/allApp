<template>
  <v-container>
    <v-form>
      <v-row align="center" justify="center" class="mt-10">
        <v-col cols="6">
          <v-file-input
            :accept="['image/jpeg', 'image/png']"
            label="INE aquí..."
            clear-icon="mdi-close-circle"
            cleareable
            dense
            show-size
            v-model="ine"
            type="file"
          ></v-file-input>
          <div class="ma-5"></div>
          <v-file-input
            :accept="['image/jpeg', 'image/png']"
            label="Selfie aquí..."
            clear-icon="mdi-close-circle"
            cleareable
            dense
            show-size
            v-model="selfie"
          ></v-file-input>
        </v-col>
      </v-row>
      <v-row justify="center">
        <v-btn color="indigo" class="ma-3" @click="uploadFiles()" :loading="uploading">Send</v-btn>
      </v-row>
    </v-form>
    <v-row justify="center" class="mt-4 mb-4">
      <h1>{{ message }}</h1>
    </v-row>
    <v-row align="center" justify="center" class="mt-4">
      <v-col cols="6">
        <v-card :loading="uploading" :color="card_color">
          <template slot="progress">
            <v-progress-linear
              color="deep-purple"
              indeterminate
            ></v-progress-linear>
          </template>
          <v-card-title class="">INE</v-card-title>
          <v-row justify="center">
            <div
              v-if="load_img"
              style="
                width: 80%;
                color: white;
                height: 600px;
                margin-bottom: 15px;
              "
            ></div>
            <v-img
              v-else
              :src="ine_src"
              max-height="600"
              max-width="90%"
              width="90%"
              height="600"
              class="mb-4"
            >
              <template v-slot:placeholder>
                <v-row class="fill-height ma-0" align="center" justify="center">
                  <v-progress-circular
                    indeterminate
                    color="grey lighten-5"
                  ></v-progress-circular>
                </v-row>
              </template>
            </v-img>
          </v-row>
        </v-card>
      </v-col>
      <v-col cols="6">
        <v-card :loading="uploading" :color="card_color">
          <template slot="progress">
            <v-progress-linear
              color="deep-purple"
              indeterminate
            ></v-progress-linear>
          </template>
          <v-card-title>SELFIE</v-card-title>
          <v-row justify="center">
            <div
              v-if="load_img"
              style="
                width: 80%;
                color: white;
                height: 600px;
                margin-bottom: 15px;
              "
            ></div>
            <v-img
              v-else
              :src="selfie_src"
              max-height="600"
              max-width="90%"
              width="90%"
              height="600"
              class="mb-4"
            >
              <template v-slot:placeholder>
                <v-row class="fill-height ma-0" align="center" justify="center">
                  <v-progress-circular
                    indeterminate
                    color="grey lighten-5"
                  ></v-progress-circular>
                </v-row>
              </template>
            </v-img>
          </v-row>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>
<script>
import axios from "axios";
import Swal from "sweetalert2";
export default {
  data() {
    return {
      ine: null,
      selfie: null,
      sended: false,
      uploading: false,
      message: "",
      card_color: "dark",
      ine_src: null,
      selfie_src: null,
      load_img: true,
    };
  },
  methods: {
    async uploadFiles() {
      this.uploading = true;
      if (!this.ine || !this.selfie)
        return Swal.fire({
          title: "¡Oops!",
          text: "Debes de seleccionar dos imágenes.",
          icon: "info",
          showCancelButton: false,
        })
        .then(() => setTimeout(() => this.uploading = false, 300));
      this.card_color = "dark";
      this.load_img = false;
      try {
        let formData = new FormData();
        formData.append("INE", this.ine);
        formData.append("selfie", this.selfie);
        const resp = await axios.post(
          "https://localhost:3000/faceRecognition",
          formData,
          {},
          {
            headers: {
              "Content-Type": "multipart/form-data",
            },
          }
        );
        if (resp.data.r == undefined)
          return Swal.fire({
            title: "¡Oops!",
            text: "No se recibió la respuesta esperada.",
            icon: "error",
            showCancelButton: false,
          }).then(() => setTimeout(() => this.uploading = false, 300));
        if (resp.data.r) this.card_color = "green";
        else this.card_color = "red";
        this.message = resp.data.message;
        // this.load_img = true;
        this.ine_src = `data:image/png;base64, ${resp.data.ine}`;
        this.selfie_src = `data:image/jpg;base64, ${resp.data.selfie}`;
        this.uploading = false;
      } catch (error) {
        console.log(error);
      }
    },
  },
};
</script>