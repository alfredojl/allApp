<template>
  <v-app>
    <v-card>
      <v-toolbar>
        <v-toolbar-title>Demo METAFINANCIERA</v-toolbar-title>

        <template v-slot:extension>
          <v-tabs v-model="tab" align-with-title>
            <v-tabs-slider></v-tabs-slider>

            <v-tab> Reconocimiento facial </v-tab>
            <v-tab> Registro de voz </v-tab>
            <v-tab> Reconocimiento de voz </v-tab>
          </v-tabs>
        </template>
      </v-toolbar>

      <v-tabs-items v-model="tab">
        <v-tab-item>
          <v-card class="mt-10">
            <v-row justify="center">
              <h2>Reconocimiento facial</h2>
            </v-row>
            <Face />
          </v-card>
        </v-tab-item>
        <v-tab-item>
          <v-card flat class="mt-10">
            <v-row justify="center">
              <h2>Registro de voz</h2>
            </v-row>
            <VoiceRegister />
          </v-card>
        </v-tab-item>
        <v-tab-item>
          <v-card flat class="mt-10">
            <v-row justify="center">
              <h2>Reconocimiento de voz</h2>
            </v-row>
            <VoiceRecognition />
          </v-card>
        </v-tab-item>
      </v-tabs-items>
    </v-card>
  </v-app>
</template>

<script>
import Face from "./views/Face.vue";
import VoiceRegister from "./views/VoiceRegister.vue";
import VoiceRecognition from "./views/VoiceRecognition.vue";
export default {
  name: "App",
  components: {
    Face,
    VoiceRegister,
    VoiceRecognition,
  },
  data: () => ({
    tab: null,
  }),
};
</script>
