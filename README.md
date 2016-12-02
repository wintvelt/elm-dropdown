# Example of a dropdown menu

Comparing a flat versus nested (component) setup.

A extensive explanation and comparison of the examples can be found here on Medium.com

The example folder contains the following examples:
- single example: baseline, a single dropdown in one main module
- nested example: using an extracted dropdown (component) - which manages its own state
- flat example: using an extraction without internal state management

## Comparison flat and nested
A rough comparison of the two extraction methods reveals:
- In total size (lines of code - including comments and docs) of the *Main.elm* module, there is not much difference between the nested and flat extraction.
- The nested *Dropdown.elm* has a lot more lines of code than in the flat variant: 141 vs 96, which is over 40% more code.

In itself, the implications of this are small. The reason for extracting the dropdown is to make the overall structure,  in particular the main module less complex. So the size of the extracted module is not very important.

The *key differences* become clear when we zoom in on the building blocks within the Main.elm modules in the 2 variants:

- the `update` function has about 30-35% more lines of code in the nested setup, compared to flat setup
- the `view` function has about 40% more lines of code in the nested setup


## In a flat setup, the code is much easier to read and to debug

In the flat setup, most of the code in our Main.elm module is static.  
The key blocks of code relevant in the programs lifecycle, where most of the "action" takes place, tends to be in the `update` and `view` functions. These are much more compact and readable in the flat setup.