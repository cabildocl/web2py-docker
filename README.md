This is a web2py docker with Python3. You can use it to develop or deploy app.

this example shows how to run:

docker run -d -p 80:80 -p 443:443 -p 8000:8000 cabildocl/web2py

for run your app:

docker run -d -p 80:80 -p 443:443 -p 8000:8000 my_app:/web2py/applications/webapp cabildocl/web2py

More info: https://cabildocl.blogspot.com Source code on github: https://github.com/cabildocl/web2py-docker
