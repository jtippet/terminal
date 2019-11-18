---
author: Mike Griese @zadjii-msft, Leon Liang @leonMSFT
created on: <yyyy-mm-dd>
last updated: <yyyy-mm-dd>
issue id: 1502
---

# Advanced Tab Switcher

## Abstract

This spec outlines the addition of a tab switcher. It would be keyboard driven and would give a pop-up display of a list of tabs in a box. The tab switcher would also be able to display the tabs in Most Recently Used (MRU) order.

## Inspiration

This was mainly inspired by the tab switcher that's used in Visual Studio Code and Visual Studio.

VSCode's tab switcher is slightly different, in that it appears directly underneath the tab bar, while Visual Studio's tab switcher presents itself as a box in the middle of the editor.

Both switchers behave very similarly, from the keychord that's pressed to show the switcher, to the way the switcher is dismissed.

## Solution Design

### How does the user open the UI?
The user will press a combination of a modifier key and any other key to bring up the tab switcher UI. By default, it will be <kbd>ctrl+tab</kbd>. The user will be able to change the keybindings, but it must have one modifier key which will act as the `anchor` key, and another key which will be the `switcher` key.

We use the term `anchor` to represent the behavior where the dialog will open when the `anchor` + `switcher` keys are pressed, but the dialog will stay open as long as the `anchor` is held down, and is only dismissed when the `anchor` is released. The `switcher` will be repeatedly pressed as the `anchor` is held down to iterate through the list of tabs.

## UI/UX Design

[comment]: # What will this fix/feature look like? How will it affect the end user?

## Capabilities

[comment]: # Discuss how the proposed fixes/features impact the following key considerations:

### Accessibility

[comment]: # How will the proposed change impact accessibility for users of screen readers, assistive input devices, etc.

### Security

[comment]: # How will the proposed change impact security?

### Reliability

[comment]: # Will the proposed change improve reliabilty? If not, why make the change?

### Compatibility

[comment]: # Will the proposed change break existing code/behaviors? If so, how, and is the breaking change "worth it"?

### Performance, Power, and Efficiency

## Potential Issues

[comment]: # What are some of the things that might cause problems with the fixes/features proposed? Consider how the user might be negatively impacted.

## Future considerations

[comment]: # What are some of the things that the fixes/features might unlock in the future? Does the implementation of this spec enable scenarios?

## Resources

[comment]: # Be sure to add links to references, resources, footnotes, etc.
