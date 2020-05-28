# Elm Lightning Talk

## About this repository

This is a toy project showcasing a few of Elm's concepts and ways to integrate Javascript, CSS and Build tools such as Webpack.

## Structure

### Concepts

In [./src/Main.elm](./src/Main.elm) you can see the classic architecture of Model, View, Update.

#### Pureness and Determinism

An example for the pureness of Elm and its implications is given with the subscription to the windows size. In JS you could just ask for the windows size when you need it, but that is a non-deterministic function, it could potentially get different values every time it is called. Then when do you rerender?
This is a problem solved by subscriptions, since the new value just comes in our update function and from there on, everything is deterministic and pure.

#### Client-Side Routing

Also, the file shows how Elm client side routing works. Interesting is, that in comparison to other JS Frameworks, we do not configure a Router, instead the change in url comes in the update function and we can decide ourselves how to handle it.
In this example, we render a button, intercepting the navigation and asking the user for confirmation.

#### JS Integration

In [./src/JSInterop.elm](./src/JSInterop.elm) we can see a port module with a bi-directional port. The javascript side of the port can be found in [./index.js](./index.js).
This simple example calculates square numbers by asking Javascript for help. Of course, you would not need to do this, since Elm can do that itself, but it serves as an example for the communication process.
Also, it shows how Elm deals with bugs in the JS Implementation or unexpected values. There is no way that a runtime exception is thrown, even if wrong, multiple or no values are returned by the port.

The file also contains an integration of a web component defined in [./index.js](./index.js), showing yet another way to communicate between JS and Elm and integrate UI-Libraries in an Elm Project.

### Styling

Elm itself does not care how you style your HTML Elements. This project shows 3 common approaches: .css Files, css in Elm with [Elm-Css](https://package.elm-lang.org/packages/rtfeldman/elm-css/latest) and [Elm-UI](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/).

#### Css Files

No surprise here: Write css files, include the classes in Elm with `Html.class`. [./src/Main.elm](./src/Main.elm) and [./src/Navbar.elm](./src/Navbar.elm) are styled this way as an example. In this case, you need a way to include your css in the bundle (seperately with link in index.html or as in this project, with webpack's style loader)

#### Elm-Css

Pretty much a standard CSS in JS library like styled components, just in Elm. Typing helps that only valid css is generated. [./src/Home.elm](./src/Home.elm) uses this technique as a showcase.

#### Elm-UI

A completely different approach to styling that compiles to CSS and Html. Layouts are based on `Element.row`, `Element.column` and `Element.paragraph` as well as `Element.el` as a generic container and `Element.text` and `Element.none` as non-nesting elements.

Accessibility and inputs are abstracted away in the `Element.Region` and `Element.Input` subpackages respectively.

Feels completely different to the usual HTML and CSS and is way easier to get the look you need once you get used to it, but might not have the smallest DOM or the best SEO result.

[./src/JSInterop.elm](./src/JSInterop.elm) uses Elm-UI to render its content.

### Testing

The currently only way of testing Elm Code is [Elm Test](https://package.elm-lang.org/packages/elm-explorations/test/latest/), which has a seperate JS CLI installable from npm.
Elm Test supports the classic unit tests but also fuzz tests, that can help testing behaviour of the code instead of specific cases.
[./tests/ElmTest.elm](./tests/ElmTest.elm) shows an example of a unit test vs a fuzz test and how a fuzz test can be an effective way of finding bugs.

Note that there is currently no way of mocking in Elm, so the only way to test Command and Subscription behaviour is restructuring your code in the way suggested by [Elm Program Test](https://package.elm-lang.org/packages/avh4/elm-program-test/latest/) or write integration(Selenium) tests.

The good news is that usually, due to the strictness of Elm:
`If it compiles it works`

### A note on code splitting

Elm produces a rather small file, however for a larger, real world application, Code Splitting might be a great improvement.
Elm does not have a code splitting solution for now, but there is a workaround using ports, which can be seen in the [./src/Codesplitting](./src/Codesplitting) folder.

### Tooling

I recommend Intellij as an IDE for Elm, VS Code Integration works but seems kind of buggy at times.
For bundling the code, there are plugins for all popular bundlers such as webpack, parcel and rollup.


