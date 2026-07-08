# Text to Music GUI 2015
Want to hear your name as a song? These Godot/Python GUIs turn text into melodies.

## To Run the Program
You can try it online or set it up locally.

### Online
Play on itch.io _(Coming soon)_

### Locally with Godot
You will need to locally install Godot 4.7, then run the Godot project.

### Locally with Python
You will need to locally install Python 2 or 3, as well as some free libraries, then run the Python file.

#### Computer Requirements
To run a Python program, the computer you use needs the following installed:

- Windows
  - Note: I have not tested `v1-python/textToMusicGUI.py` on a Mac. It may work.
- Python 3
  - Note: If it only has Python 2, then you must alter two lines of code and save the changes:
    - Uncomment Line 29
    - Comment-Out Line 32
- Three modules:
  - `tkinter` AND/OR `Tkinter`
  - `time`
  - `winsound`

Python 2, Python 3, and all three modules are available online for free.

#### Installation Steps
Below are instructions to run the program:

1. Download file `v1-python/textToMusicGUI.py` to a (Windows) computer (with Python installed)
2. (Optionally) Move or Copy `v1-python/textToMusicGUI.py` to your Desktop
3. Right-click `v1-python/textToMusicGUI.py`
4. Select `Edit with IDLE`
5. Run the program by either:
  - ... pressing `F5`
  - ... click `Run`, then click `Run Module`

#### Screenshots
Below are a couple of example screenshots of the Python version:

![example-screenshot-empty](https://user-images.githubusercontent.com/11843918/233766240-24976080-ec2a-44ba-b194-9ae42547dc9e.png)
![example-screenshot-abc](https://user-images.githubusercontent.com/11843918/233766241-ff885a4d-7123-4a1a-9c8b-3fe88e7b481e.png)

_**Screenshot 1:** The GUI starts empty, waiting for a string to translate._
_**Screenshot 2:** After filling in the top input and clicking Translate, then the music will be filled in and each version may be listened to by clicking a Play button._

## Credits
The original Python version `v1-python/textToMusicGUI.py` was first completed on June 6th, 2015 by Noah Bumgardner as a single-file application.

The more modern Godot version started in 2024 is also by Noah Bumgardner, this time as a browser friendly project.

### Attributions
Open source resources used:

- [Godot-Onscreen-Keyboard](https://github.com/martinfuchs/Godot-Onscreen-Keyboard) plugin by Martin Fuchs and contributors.
- [Roboto](https://github.com/martinfuchs/Godot-Onscreen-Keyboard) font by Christian Robertson.

Coded using the [Python](https://www.python.org) language and the [Godot](https://godotengine.org) game engine.

The latest stable `main` code branch runs on Godot version 4.7.
