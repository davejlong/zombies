<template>
  <body>
    <div class="container">
      <div class="row">
        <div class="column">
          <form v-on:submit="save">
            <p>Zombies can attack at any time! Be vigilant and know when you're at risk.</p>
            <div class="success" v-if="subscribed">You're now subscribed for alerts! Stay vigilant.</div>
            <label for="phoneNumberField">Phone Number</label>
            <input type="text" placeholder="+1 555-555-5555" id="phoneNumberField" v-model="phoneNumber" v-bind:class="{error: hasError}" />
            <input type="submit" value="Subscribe" />
          </form>
        </div>
      </div>
    </div>
  </body>
</template>

<script>
export default {
  data: () => {
    return { phoneNumber: undefined, hasError: undefined, subscribed: false };
  },
  methods: { save }
};

function save(e) {
  var self = this;
  e.preventDefault();
  if (!this.phoneNumber) {
    this.hasError = true;
    return false;
  } else { this.hasError = false; }
  const xhr = new XMLHttpRequest();
  xhr.onload = function() {
    self.subscribed = true;
    self.phoneNumber = undefined;
  };
  xhr.open("POST", "/subscribe", true);
  xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
  xhr.send(`phonenumber=${this.phoneNumber}`);
}
</script>

<style src="../../style/App.scss" lang="scss"></style>
