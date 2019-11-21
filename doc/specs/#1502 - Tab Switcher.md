---
author: Mike Griese @zadjii-msft, Leon Liang @leonMSFT
created on: <yyyy-mm-dd>
last updated: <yyyy-mm-dd>
issue id: 1502
---

# Advanced Tab Switcher

## Abstract

Currently, the user is able to cycle through tabs on the tab bar. However, this horizontal cycling can be pretty inconvenient when the tab titles are long, or when there are too many tabs on the tab bar. In addition, a common use case is to switch between two tabs, e.g. when one tab is used as reference and the other is the actively worked-on tab. If the tabs are not right next to each other on the tab bar, it could be difficult to quickly swap between the two. To try to alleviate some of those pain points, we want to create an advanced tab switcher.

This spec will cover the design of the switcher, and how a user would interact with the switcher. It would be keyboard driven and would give a pop-up display of a vertical list of tabs in a box. The tab switcher would also be able to display the tabs in Most Recently Used (MRU) order, which allows a user to quickly switch between two tabs with a single keychord press.

## Inspiration

This was mainly inspired by the tab switcher that's found in Visual Studio Code and Visual Studio.

VS Code's tab switcher appears directly underneath the tab bar, while Visual Studio's tab switcher presents itself as a box in the middle of the editor.

Both switchers behave very similarly, from the keychord that's pressed to show the switcher, to the way the switcher is dismissed and navigated.

## Solution Design

### Using the Switcher 

#### Opening the Tab Switcher
The user will press a combination of a modifier key and any other key/keychord to bring up the UI. For example, <kbd>ctrl+tab</kbd> and <kbd>ctrl+shift+tab</kbd> are popular keychords for opening tab switchers and navigating them. We'll allow the user to change these keybindings, but we'll require that there is a combination of a modifier key (the `anchor` key) and one other key (the `switcher` key).

#### Keeping it open
There are two ways the user can keep the UI open after bringing it up.
1. The UI will stay open as long as the `anchor` key is held down. (`Anchor` mode is on).
1. The UI will stay open even after the `anchor` key is released. (`Anchor` mode is off - _This is the default_).

There will be a setting that allows the user to turn `Anchor` mode on and off. _By default_, the tab switcher will _not_ be in anchor mode.

#### Switching through Tabs
The user can repeatedly press the `switcher` key or <kbd>shift</kbd> + `switcher` to navigate down or up the list of tabs in the UI. They can also use arrow keys to go up or down the list.

As the user is cycling through the tab list, the terminal won't actually switch to the selected tab. It will keep displaying the current open tab until the switcher is dismissed with an `anchor` release or with <kbd>esc</kbd>.

TODO: Do we want the user to be able to click on the tab to select it?

#### Closing the UI
1. If `Anchor` mode is on, the UI will be dismissed when the `anchor` key is released. It can also be dismissed when a `dismissal` key is pressed (such as <kbd>esc</kbd> or <kbd>enter</kbd>).
1. If `Anchor` mode is off, the UI will only be dismissed when a `dismissal` key is pressed.

The two dismissal keys are <kbd>esc</kbd> and <kbd>enter</kbd>. When <kbd>esc</kbd> is pressed, the UI will dismiss without switching to the selected tab, effectively cancelling the tab switch. When <kbd>enter</kbd> is pressed, the UI will dismiss, and terminal will switch to the selected tab.

TODO: What happens if the user presses the keychord for opening again? Should it dismiss? Should it do nothing?

### Most Recently Used Order
We'll provide a setting that will allow the list of tabs to be presented in either _in-order_ (_aka_. how the tabs are ordered on the tab bar), or _Most Recently Used Order_(MRU). MRU means that the tab that the terminal most recently visited will be on the top of the list, and the tab that the terminal has not visited for the longest time will be on the bottom. 

This means that each tab will need to be kept track of in an MRU stack, and every time a tab comes into focus, that tab is taken out of the MRU stack and placed on the top. The tab switcher will then display the stack from top to bottom as the list of tabs in MRU order.

### Numbered Tabs
Similar to how the user can currently switch to a particular tab with a combination of keys such as <kbd>ctrl+shift+1</kbd>, we want to have the tab switcher provide a number to each tab displayed on the tab switcher. After the user opens up the tab switcher, they can then press a number to switch to the tab assigned to that number.

TODO: Ok, well what if the user has like 1000 tabs, we can't just give 0-999 to the tabs? Or can we? Should we just limit the number of tabs that get a number to 0-9? In this case, any other tab past the 10th tab will have to be cycled to. Or maybe it can be clicked on?

### Other features to consider that may or may not be included in this implementation.
#### Exposing Panes 
#### Tab Search by Name/Title
#### Tab Preview on hover

## What does it look like?

[comment]: # What will this fix/feature look like? How will it affect the end user?

## Capabilities

### Accessibility

[comment]: # How will the proposed change impact accessibility for users of screen readers, assistive input devices, etc.

### Security

This won't introduce any new security issues.

### Reliability

TODO :The only thing I could think of is if there's an enormous amount of tabs present? Even then, as long as the data structures used to keep track of MRU are implemented well, it shouldn't cause any bottlenecks. Not fully sure on what else there is for this point.

### Compatibility

The existing way of navigating horizontally through the tabs on the tab bar should not break.

### Performance, Power, and Efficiency

## Potential Issues



## Future considerations

[comment]: # What are some of the things that the fixes/features might unlock in the future? Does the implementation of this spec enable scenarios?

## Resources

[comment]: # Be sure to add links to references, resources, footnotes, etc.
