import { Elm } from "./Main.elm";

const elmApp = Elm.Codesplitting.Main.init();

elmApp.ports.changeRoute.subscribe((route) => {
  switch (route) {
    case "/":
      import("./Home.elm").then((Home) => {
        Home.Elm.Codesplitting.Home.init({
          node: document.getElementById("content").firstChild,
        });
      });
      break;

    case "/route1":
      import("./Route1.elm").then((Route1) => {
        Route1.Elm.Codesplitting.Route1.init({
          node: document.getElementById("content").firstChild,
        });
      });
      break;

    case "/route2":
      import("./Route2.elm").then((Route2) => {
        Route2.Elm.Codesplitting.Route2.init({
          node: document.getElementById("content").firstChild,
        });
      });
      break;
    default:
  }
});
