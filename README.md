# Example of a dropdown menu

Comparing a pure versus stateful (component) setup.

A extensive explanation and comparison of the examples can be found [here on Medium.com][1]

The example folder contains the following examples:
- single example: baseline, a single dropdown in one main module
- stateful example: using an extracted dropdown (component) - which manages its own state
- pure example: using an extraction without internal state management

## Comparison pure and stateful
A rough comparison of the two extraction methods reveals:
- In total size (lines of code - including comments and docs) of the *Main.elm* module, there is not much difference between the stateful and pure extraction. The pure version is slightly larger.
- The stateful *Dropdown.elm* has about 40% more code. In itself, the implications of this are small. The reason for extracting the dropdown is to make the overall structure, in particular the main module, less complex. So the size of the extracted module is not very important.

The *key difference* becomes clear when we zoom in on the building blocks within the Main.elm modules in the 2 variants:

- the `update` function has about 30-35% more lines of code in the stateful setup, compared to pure setup


## In a pure setup, the code is much easier to read and to debug

In the pure setup, most of the code in our Main.elm module is static.  
The key blocks of code relevant in the programs lifecycle, where most of the "action" takes place, tends to be in the `update` function. This is much more compact and readable in the pure setup.


[1]: https://medium.com/@wintvelt/a-reusable-dropdown-in-elm-part-1-d7ac2d106f13

## Run

Use `elm reactor` or `elm-live`:

`elm-live examples/pure/Main.elm`

You can also run `elm-live` with `debug`:

`elm-live examples/pure/Main.elm -- --debug`
