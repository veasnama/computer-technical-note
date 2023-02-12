# > How django works on the surface 

- Getting started
	- In django, First There are two important things 
		- Project 
		- App
	- Project
		- Settings configuration 
		- Url pattern for our project
		- WSGI how our web app connect with web server

- Appliation and Route
	- We configure route in urls.py  file 
		- The file can in project and app
		- example we navigate to /blog/about
			- django will look at urls.py in our project and it see the url pattern 
			then it will chop off the blog/ and send the remaining string to blog.urls 
			the string is about for further processing 
			Next it will look at urls.py in our blog app and see about/ . then it asked what function handle this about/ then it see blog.views and look at the views and see about function and next the function return HttpsRespone which has <h1> About blog </h1>  

- Templates
	- Most of the time django will use tempaltes in the app directory 
	- How 
		- Create a subdirectory in our app with the name "templates"	
		- Create our html file to further rendering 
		- Go to our views.py and < render function > from django.shortcuts
		return render(request, "blog/*.html", context)