namespace.lsp adds java-like namespaces to newLISP!

You can do stuff like:

	(ns-import 'com.example.*)
	(ns-import 'com.example.Test)

To understand what this is and how it works just follow these steps:

1) Run main.lsp in the project directory.

	[prompt]$ newlisp main.lsp

2) Read main.lsp
3) Look at the directory structure in src/
4) Look inside Bar.lsp, Foo.lsp, and Test.lsp.
5) Learn about Objective newLISP if you haven't already, but this is optional! you don't need to use ObjNL with namespace.lsp if you don't want.

For an even deeper understanding of how it works, look at ns-create and ns-import in namespace.lsp. There's only 2 short functions to get this functionality! The rest is just making sure your directory structure follows the "package path".

I.e. if you've got a context Test and its package path is: com.example.Test
Your Test.lsp file should be inside com/example.
