# very-raw-html-blog-engine
A very simple pipline to publish blog on github (or anywhere else). A working example: https://yzahkin.games/blog
This repo as a working blog: https://akosnikhazy.github.io/very-raw-html-blog-engine/

## how does it work?
This is a very crude way of writing a blog. Since GitHub does not have dynamic site building capabilities (or you just want something small and fast anyway), you write the blog on your computer by hand writing posts in html files and then uploading them to GitHub.
This solves the problem of having an index.html, rss.xml and sitemap.xml file with the latest posts in it. These are difficult to update by hand. The PowerShell script is here to help!

## how to publish blog posts?
While you can change a lot in the ```build-index.ps1``` file, by default you have a ``posts`` folder. In this folder you should create folders named as Y-m-d dates (e.g. 2024-11-30). This will be the publication date of the posts. You create posts by creating HTML files in these date folders. All you need is an h1 tag for the title and at least one p tag for the text. Everything else is optional.The best practice is to create a nice blog post design and every time you want to write a new post, just copy that, fill in the blanks and you are good to go.

When you have finished writing your blog post, you need to run the build-index.ps1 PowerShell script. This will create the index.html, sitemap.xml and rss.xml files for you.

Then just upload the whole blog to GitHub. Or wherever you want. It is a good idea to clone the repository where your blog will be hosted and copy these files there. Then you can update it like a pro.

## how to change design?
You can change the ``index-template.html`` and ``post-template.html`` files as you like, just leave the ``{{tags}}`` where you need content. 

In index-template.html, ```{{list}}``` is where the list of blog posts will appear after templating.

In post-template.html, ```{{path}}``` will have the full path of the blog post, ```{{title}}``` ```{{date}}``` and ```{{text}``` will show the ```h1``` title, containing the folder name and the first ```p``` tag's text in the given post.

## Jekyll does this but better?
Yes. But for my blog it is an overkill. If you want something more robust feel free to use that: https://github.com/jekyll/jekyll
