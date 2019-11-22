---
author: Mike Griese @zadjii-msft, Leon Liang @leonMSFT
created on: <yyyy-mm-dd>
last updated: <yyyy-mm-dd>
issue id: 1502
---

# Advanced Tab Switcher

## Abstract

Currently, the user is able to cycle through tabs on the tab bar. However, this horizontal cycling can be pretty inconvenient when the tab titles are long, or when there are too many tabs on the tab bar. In addition, a common use case is to switch between two tabs, e.g. when one tab is used as reference and the other is the actively worked-on tab. If the tabs are not right next to each other on the tab bar, it could be difficult to quickly swap between the two. To try to alleviate some of those pain points, we want to create an advanced tab switcher.

This spec will cover the design of the switcher, and how a user would interact with the switcher. It would be primarily keyboard driven, and would give a pop-up display of a vertical list of tabs. The tab switcher would also be able to display the tabs in Most Recently Used (MRU) order.

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

While the user will be able to click on a tab in the switcher to bring the tab into focus, hovering over a tab with the mouse will not cause the tab highlight to go to that tab.

#### Closing the UI

1. If `Anchor` mode is on, the UI will be dismissed when the `anchor` key is released. It can also be dismissed when a `dismissal` key is pressed.
2. If `Anchor` mode is off, the UI will only be dismissed when a `dismissal` key is pressed.

The following can be applied when `Anchor` mode is both on and off.

1. The user can press a number associated with a tab to instantly switch to the tab and dismiss the switcher.
2. The user can click on a tab to instantly switch to the tab and dismiss the switcher.
3. The user can click outside of the UI to dismiss the switcher without bringing the selected tab into focus.

The two `dismissal` keys are <kbd>esc</kbd> and <kbd>enter</kbd>. When <kbd>esc</kbd> is pressed, the UI will dismiss without switching to the selected tab, effectively cancelling the tab switch. When <kbd>enter</kbd> is pressed, the UI will dismiss, and terminal will switch to the selected tab.

If the user presses the keychord for opening the switcher will not close the UI, it will iterate to the next tab in the list.

### Most Recently Used Order

We'll provide a setting that will allow the list of tabs to be presented in either _in-order_ (basically how the tabs are ordered on the tab bar), or _Most Recently Used Order_ (MRU). MRU means that the tab that the terminal most recently visited will be on the top of the list, and the tab that the terminal has not visited for the longest time will be on the bottom.

This means that each tab will need to be kept track of in an MRU stack, and every time a tab comes into focus, that tab is taken out of the MRU stack and placed on the top. The order of tabs in this stack will effectively be the order of tabs seen in the switcher.

How does a tab notify that it has come into focus recently? Since there's multiple ways of bringing a tab into focus (clicking on it, nextTab/prevTab into it, <kbd>ctrl+shift+1/2/3</kbd> into it), all of these need to let the MRU stack to know to update.

### Numbered Tabs

Similar to how the user can currently switch to a particular tab with a combination of keys such as <kbd>ctrl+shift+1</kbd>, we want to have the tab switcher provide a number to the first nine tabs (1-9) in the list for quick switching. If there are more than nine tabs in the list, then the rest of the tabs will not have a number assigned.

Once the tab switcher is open, and the user presses a number, the tab switcher will be dismissed and the terminal will bring that tab into focus.

### Settings and Key Bindings

- `AnchorMode`
    - _default_ = `false`
    - If `true`, the UI will dismiss on the `Anchor` key release.
- `OpenTabSwitcher`
    - _default_ = <kbd>ctrl+tab</kbd>
- `TabSwitchDown`
    - _default_ = <kbd>tab</kbd> or <kbd>downArrow</kbd>
- `TabSwitchUp`
    - _default_ = <kbd>shift+tab</kbd> or <kbd>upArrow</kbd>
- `AnchorKey`
    - _default_ = <kbd>ctrl</kbd>

## UI Design

The dialog window will open with the size as a percentage of the window height (TODO: which maybe should be configurable?). The tabs and their titles will be laid out vertically, and the selected tab will be highlighted. To the left of the first nine tab titles will be a column to signify which number the tab is associated with (1-9). The user can quickly jump to a numbered tab without having to cycle through the list by simply pressing the number. The list will scroll if there isn't enough space to fit all the tabs in the box.

## Capabilities

### Accessibility

TODO:

### Security

This won't introduce any new security issues.

### Reliability

TODO :The only thing I could think of is if there's an enormous amount of tabs present? Even then, as long as the data structures used to keep track of MRU are implemented well, it shouldn't cause any bottlenecks. Not fully sure on what else there is for this point.

### Compatibility

The existing way of navigating horizontally through the tabs on the tab bar should not break.

### Performance, Power, and Efficiency

## Potential Issues

N/A

## Future considerations

1. Pane Navigation
2. Tab Search by Name/Title
3. Tab Preview on Hover

## Resources

<!-- Footnotes -->
[#973]: https://github.com/microsoft/terminal/issues/973
[#1502]: https://github.com/microsoft/terminal/issues/1502
[#2046]: https://github.com/microsoft/terminal/issues/2046
