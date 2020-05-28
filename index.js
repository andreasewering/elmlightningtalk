import ConfettiGenerator from "confetti-js";
import "./main.css";
import { Elm } from "./src/Main.elm";

// flags

const elmApp = Elm.Main.init({
  flags: { x: window.innerWidth, y: window.innerHeight },
});

// ports

elmApp.ports.toJs.subscribe((value) => {
  if (value === 4) {
    elmApp.ports.fromJs.send("undefined is not a function");
  }
  if (value < 7 && value !== 4) {
    elmApp.ports.fromJs.send(value * value);
  }
  if (value === 10) {
    elmApp.ports.fromJs.send(1337);
    elmApp.ports.fromJs.send(1337);
    elmApp.ports.fromJs.send(1337);
  }
});

// customElements

const template = document.createElement("template");
template.innerHTML = `
<style>
.writer {
    background-color: #EEEEEE;
    cursor: pointer;
    display: inline-block;
    padding: 10px;
}
.canvas {
    height: 100vh;
    position: absolute;
    width: 100vw;
    top: 0;
    left: 0;
    pointer-events: none;
}
</style>
<canvas class="canvas"></canvas>
<div class="writer">
<slot></slot>
</div>`;

class ElmSender extends HTMLElement {
  constructor() {
    super();
    this.attachShadow({ mode: "open" });
  }

  connectedCallback() {
    this.shadowRoot.appendChild(template.content.cloneNode(true));
    this.addEventListener("click", () => {
      this.dispatchEvent(new CustomEvent("sendtoelm"));

      const canvas = this.shadowRoot.querySelector("canvas");
      const confetti = new ConfettiGenerator({ target: canvas });
      confetti.render();
      setTimeout(confetti.clear, 2000);
    });
  }
}

customElements.define("elm-sender", ElmSender);
