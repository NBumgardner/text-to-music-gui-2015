# Text to Music GUI 2015
Want to hear your name as a song? These Godot/Python GUIs turn text into melodies.

## How to Use
To create and hear a translation:

1. Type text into the first line labeled _Input Text_.
2. Press the _Translate_ button, the second button starting from the top-right corner.
3. The program automatically fills the remaining rows with Solfège correlating to each letter.
  - _A_ becomes _Do_, the first note of each scale.
  - _B_ becomes the second note of each scale.
  - _C_ becomes the third, and so on.
  - When a letter is beyond the number of notes in the scale, then it wraps back around to _Do_.
4. Press the _Play_ button of the translated row you wish to hear.

Additionally, Solfège music may be edited by hand, and playback may be sped up within the _Settings_ opened from the top-right corner of the screen.

### Translation Logic
Each letter to translate is calculated as a modulo of the number of notes in the scale. For example:

  - _A_ becomes _Do_, the first note of each scale.
  - _B_ becomes the second note of each scale.
  - _C_ becomes the third, and so on.
  - The first letter beyond the number of notes in the scale wraps around to the first note of the scale.
  - The second letter beyond the number of notes in the scale uses the second note of the scale.
  - The third letter beyond becomes the third, and so on.
  - This mapping process is repeated A-Z, case-insensitive.
  - Non-letters become _(rest)_, which is a musical rest of silence.

### Playback Logic
12 unique pitches of playback are supported. The playback text is currently case sensitive, so if you write music by hand, make sure to capitalize the first letter of each accidental pitch. The list of notes is:

1. Do
2. di, ra
3. Re
4. ri, me
5. Mi
6. Fa
7. fi, se
8. So
9. si, le
10. La
11. te, li
12. Ti

Enforcement of spellings could be loosened in future pull requests. The Godot implementation has a list of all legal spellings in file `chromatic_with_all_solfege.tres` property `solfege_ascending_string`.

## To Run the Program
You can try it online or set it up locally.

### Online
Play on itch.io _(Coming soon)_

### Locally with Godot
You will need to locally install Godot 4.7, then run the Godot project.

#### Screenshots of Godot Version

<img width="720" height="500" alt="image" src="https://github.com/user-attachments/assets/74477525-09b6-42e4-be68-e67f74d0b9e0" />

_**Screenshot 1:** After filling in the top input and clicking Translate, then the music will be filled in and each version may be listened to by clicking a Play button._


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

#### Screenshots of Python Version
Below are a couple of example screenshots of the Python version:

![example-screenshot-empty](https://user-images.githubusercontent.com/11843918/233766240-24976080-ec2a-44ba-b194-9ae42547dc9e.png)
![example-screenshot-abc](https://user-images.githubusercontent.com/11843918/233766241-ff885a4d-7123-4a1a-9c8b-3fe88e7b481e.png)

_**Screenshot 2:** The GUI starts empty, waiting for a string to translate._
_**Screenshot 3:** After filling in the top input and clicking Translate, then the music will be filled in and each version may be listened to by clicking a Play button._

## How to Contribute
Updating the Godot version is easier since it is made of multiple files.

If a pull request changes how the Godot version looks, then please regenerate the project's icon SVG as part of the pull request:

1. Locally run the `thumbnail` scene.
2. Take a screenshot.
3. Open a separate image editor application.
4. Crop out the gray outer area.
5. Convert the cropped image into an SVG file.
6. Replace file `project-icon.svg`.
7. Replace the Project -> Application -> Config -> Icon path with the new file.
8. Verify the project list view of the Godot project is updated.

In contrast, the Python version should stay as a single file for simplicity of downloading and using it.

## Credits
The original Python version `v1-python/textToMusicGUI.py` was first completed on June 6th, 2015 by Noah Bumgardner as a single-file application.

The more modern Godot version started in 2024 is also by Noah Bumgardner, this time as a browser friendly project.

### Attributions
Open source resources used:

- [Godot-Onscreen-Keyboard](https://github.com/martinfuchs/Godot-Onscreen-Keyboard) plugin by Martin Fuchs and contributors.
- [Roboto](https://github.com/martinfuchs/Godot-Onscreen-Keyboard) font by Christian Robertson.

Coded using the [Python](https://www.python.org) language and the [Godot](https://godotengine.org) game engine.

The latest stable `main` code branch runs on Godot version 4.7.
