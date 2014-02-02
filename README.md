FileSystem in iOS


During the process of working on a project. Had a requirement to develop a fully dynamic file handling/management system. So to get a better idea i started developing an example app to do it. So I started from scratch, developing Filesystem project. Have implemented many features that are not easy to find on the internet. This might be helpful in many aspects.
Have tried to write the code as dynamically as possible. Implemented the functions using least number of global variables, which makes the functions reusable.
Few features are as such:
1) Accordian heirarchy for file selection implemented in UITableview.
https://github.com/appsome/AccordionView
2) BLOCK_ALERT is a very sleek and easy to use alertview equipped with block implementation which makes it easy to use. It has many more benefits.
https://github.com/gpambrozio/BlockAlertsAnd-ActionSheets
3) SVProgressHUD is used as well.
4) Zipping a directory. This took me a while to implement because I was helpless finding a library which can zip a directory/folder with sub-folder heirarchy. This could be very useful in many apps. Use this below example to see what it does. I have created a binary both for ios simulator and device. So you can use it directly.
http://ios.biomsoft.com/2011/08/27/zipkit-example/
5) Tried to implement the Grid as dynamic as possible. Has scope for many changes.
6) Tried to add as many file operations that could be possible in iOS. Still a few left which you can try.
7) Provided both grid and table view.
8) Simple single selected file mailing and also multiple files zipped into one and then mailed. (Future apps can use this feature extensively.)
9) Sorting using different kinds.
10) Add new folder.
11) Moving files. (Copying is left, you guys can try that.)
12) Deleting files.
13) Renaming files.
14) Multiple selection.
15) Animation to drag files into folder and move through the grid.
16) Full file structure in document directory browseable with push animation.
17) Detailed file description like name, size, number of files in a folder, mod date, created date and a few more details.
18) Mime type/File type finding without internet.(This could be used extensively.)
19) UIDocumentInteractionController for previewing any type of documents/files is neglected, but according to me it is very useful tool provided by apple since ver. 3.1 or 3.2. Easy to use and very adaptable. Can display pdf's, docs and many other documents, play video and audio files, view images etc.
Many other stuff. Just check it out. Still not complete, so u guys can make some useful additions to it. This kind to structural implementation could be used with server communications with cloud for file handling. So +Add some files in the document directory of the project and play with it.

Any queries, just mail me at jai.dhorajia@gmail.com  .

Thank you,
Cian
