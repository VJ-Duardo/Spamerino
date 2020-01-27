# Spamerino

[![GitHub Downloads](https://img.shields.io/github/downloads/VJ-Duardo/Spamerino/total)](https://github.com/VJ-Duardo/Spamerino/releases)


__Spamerino__ allows you to spam anything "automaticially". 

Currently the program is in a early stage with lots to do and many bugs.

# Usage

## Edit

On startup you should see the whole interface. In the __edit__ box you paste in your text. Now, the program works by giving you a small part of your text with every enter-press. You define these parts in your text by using __newlines__. 

For example, pasting this: 

>Part1 <br>
>Part2 

will result in two parts since there is a newline inbetween.


### Saving and Creating a New Text

You are able to save your text to use or edit it later. To do this you can press __Save__ under __File__ in the menubar, or just press __Ctrl+S__. Keep in mind that unsaved changes will be gone once you switch to another saved text.
By pressing __New__ under __File__ or pressing __Ctrl+N__ you can make a new text. 


### Deleting a text

Selecting an element in the listbox and pressing the __Delete__ button will delete that element.


### Before/After Inputboxes

Whatever will be written here, will be added to each part. Text in these boxes will not be saved.

<br>

## Controls

### Play 
Once you pressed the __Play__ button, the program will give you 2 seconds until it pastes the first part. On windows you would hear a sound if an element you can paste text into is not seleted, once the time ran out.
Now that the first part is pasted in, you would naturally send it (assuming this program is used in a kind of chat) by pressing _enter_. After that you will get 500ms, or half a second, until the next part is pasted it.
<br>

### Pause
The __Pause__ button pauses the program, which means that pressing _enter_ has no effect on the procedure in this state. 
<br>

### Stop/Cancel
The __Stop__ button cancels the procedure and returns you to edit.
<br>

### Skip forward/backward
The two arrows let you skip forward and backward in parts. For instance: pressing the left arrow until its grayed out means, that the next part will be the first part. 
