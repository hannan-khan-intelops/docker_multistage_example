# we will be using the python:3 image for our BUILD stage.
FROM python:3 AS BUILD

# we set the working directory for our application.
WORKDIR /usr/src/app

# we copy the requirements file to the working directory (shown here as ./)
COPY requirements.txt ./

# we install all of the requirements/dependencies (including the pyinstaller)
RUN pip install --user --no-cache-dir -r requirements.txt

# the contents of the working directory (host) are copied into the image (container).
COPY . .

# now that we have pyinstaller installed, we can create an executable file for linux.
RUN python -m PyInstaller --onefile app.py


# the previous program has created a folder called dist, which has our executable.
# we will copy that same executable file, from our previous stage(image), into our next
# stage (image). So now we will start our RUN stage.
FROM python:slim-bullseye AS RUN

# we set the workdir for the new image
WORKDIR /usr/bin/app

# we copy our distribution (dist folder) from our first stage to our second.
# note the path we are adding to. This same path needs to be added to the
# environment PATH for the application to run.
COPY --from=BUILD /usr/src/app/dist/app /usr/bin/app

# add our path to ENV path, so that our app can be executed easily.
ENV PATH=/usr/bin/app:$PATH

CMD [ "app" ]