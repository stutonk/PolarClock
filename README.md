# PolarClock

![PolarClock in action!](https://github.com/stutonk/PolarClock/blob/master/screenshot.png)

This was an experiment to learn about contemporary Elm as well as programmatic
generation of SVG animations. The goal was to reproduce something along the
lines of [this](http://blog.pixelbreaker.com/polarclock). Though there are a
few rough spots, I'm quite pleased with how easy it is to develop in Elm.
Functional Reactive Programming seems to be a good fit for animations in any
case and the mapping of list constructs over XML isn't too onerous.

## Building
`elm-make PolarClock.elm`
