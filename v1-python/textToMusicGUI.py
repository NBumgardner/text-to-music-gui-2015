"""
textToMusicGUI.py:  GUI to translate A-Z and a-z
  text into solfege names. All buttons print messages.
  The window's size is 5x3 (row x column).
Author:  Noah Bumgardner
Last Edited: 2015 / 6 / 20 - 9:29 A. M.

__Explanation__
Music-Key: A Major. Do begins at A4, at 440hz.
How It Works:  The GUI converts text [A-Za-z ] into music
  by translating a string, such as a name, into integers.
  Those integers are converted into a smaller range, such
  as from 0-12, using the modulo operation (%). The GUI can
  perform solfege by playing beeps from the computer, where
  'Do' == A4 in music.

__Development Notes__
First Complete Version:  'convert_gui_v36polish.py'
Programming Notes:  This program has not yet been checked
  for good programming practices. For example, each Entry
  field should probably be given its own get() and set()
  functions.
Ajustability-Q: The number of rows could easily be extended
  to add additional scales to the GUI. How can get()
  functions be created dynamically, to match the number of
  Entry fields?
Ajustability-A:
"""
# from Tkinter import *
# If using Python 2: Uncomment the line above,
#                    comment the line below.
from tkinter import *
import time, winsound


def beepList(P, s):
    """
    Plays notes from P, a list of integers.
      0 is 'A4', +-1 is a half step away.
      Accepts negative values.
    s, integer for note length.
    """
    for note in P:
        f = int(440 * (2 ** (note/12.)))
        winsound.Beep(f, s)


def iltsolfege(intsList, scaleNames):
    """
    Translates each list of integers, within a list, into a
      string of solfege names.
    N: Currently only for Major scale.
    iltsolfege means Integers_List_To_Solfege

    >>> iltsolfege([[0, 1, 2]], "Do Re Mi Fa So La Ti".split())
    ['Do Re Mi']
    >>> iltsolfege([[0, 1, 2], [0,3,4]], "Do Re Mi Fa So La Ti".split())
    ['Do Re Mi', 'Do Fa So']
    """
    mod = len(scaleNames)
    result = []
    for nums in intsList:
        temp = []
        for num in nums:
            noteIndex = num % mod
            temp += [scaleNames[noteIndex]]
        temp = ' '.join(temp)
        result.append(temp)
    return result


def iListsToSolfege(intsLists, scaleNames):
    """
    iListsToSolfege means Integers_Lists_To_Solfege

    >>> iListsToSolfege([[0, 1, 2]], "Do Re Mi Fa So La Ti".split())
    "Do Re Mi"
    >>> iListsToSolfege([[0], [0], [0]], "Do Re Mi Fa So La Ti".split())
    "Do (rest) Do (rest) Do"
    """
    strList = iltsolfege(intsLists, scaleNames)
    return ' (rest) '.join(strList)


# From 'convert_v2.py'
def myStrToInt(s, scale=12):
    """
    'scale' means the number of unique tones
      in the scale used.
    """
    result = []
    # For each character in s
    for char in s:
        num = ord(char) - 65
        if (not (-1 < num < 26)):
            # Invalid character detected. Skip it.
            continue
        result.append(num % scale)
    return result


# From 'convert_v2.py'
def prepareStr(s):
    """
    Input:  String.
    Output: Caps locked list of strings, where each word is
              an element.
            Removes whitespace characters.
    """
    return s.strip().upper().split()


class App:
    def __init__(self, master):
        """Creates 3x5 grid of widgets."""
        # Initialize values.
        self._caseSensitive = False
        self._noteLength = 500
        self.userInput = StringVar()
        self.playVars = []
        headers = ['Scale Name', 'Solfege', 'Hear']
        scales = ['Chromatic', 'Major', 'Nat. Minor', 'Pentatonic']
        SCALE_CHROM_UP = "Do di Re ri Mi Fa fi So si La li Ti".split()
        SCALE_MAJOR = "Do Re Mi Fa So La Ti".split()
        SCALE_MINOR_NA = "Do Re me Fa So le te".split()
        SCALE_MAJOR_PENTA = "Do Re Mi So La".split()
        
        self._scaleInSolfege = [SCALE_CHROM_UP, SCALE_MAJOR,
                          SCALE_MINOR_NA, SCALE_MAJOR_PENTA]
        r = 0

        # Create row for user-input.
        Label(master, text='Input Text:', relief=RIDGE,
              width=11).grid(row=r, column=0)
        Entry(master, relief=SUNKEN, textvariable=self.userInput,
              width=20).grid(row=r, column=1)
        Button(master, text='Translate', relief=RIDGE, bg='blue',
               command=self.translateButton,
               width=9).grid(row=r, column=2)
        r += 1

        # Create other rows.
        for s in scales:
            Label(master, text=s, relief=RIDGE,
                  width=15).grid(row=r, column=0)
            x = Entry(master, relief=SUNKEN,
                  width=20)
            # playVars.append(x)
            self.playVars.append(x)
            x.grid(row=r, column=1)
            Button(master, text='Play', relief=RIDGE, bg='green',
                   command=self.playScale_v4(s, self.playVars[-1]),
                   width=5).grid(row=r, column=2)
            
            r += 1

    def playScale_v4(self, scale, entryFieldNumber):
        """
        scale: Valid list of strings, pre-sorted from
          lowest to hightest pitch.
        entryFieldNumber.get(): Will access one Entry
          field in the App.
        Output: Returns a function to perform the solfege
          written in the adjacent Entry field.
        """
        def f():
            print(scale, 'scale button was pressed.')
            inputSolfege = entryFieldNumber.get()
            perform = self.readSolfegeIn()
            perform(inputSolfege)
            return
        return f

    def readSolfegeIn(self, chromatic=True):
        """
        Returns a function, which performs a string of
          vaild solfege symbols (or cDict keys).
          '(rest)' is also a valid token.
        """
        # cDict means ChromaticDictionary
        cDict = {}
        cDict['Do'] = 0
        cDict['di'] = 1
        cDict['ra'] = 1
        cDict['Re'] = 2
        cDict['ri'] = 3
        cDict['me'] = 3
        cDict['Mi'] = 4
        cDict['Fa'] = 5
        cDict['fi'] = 6
        cDict['se'] = 6
        cDict['So'] = 7
        cDict['si'] = 8
        cDict['le'] = 8
        cDict['La'] = 9
        cDict['li'] = 10
        cDict['te'] = 10
        cDict['Ti'] = 11
        def readSolfege_v2(sing):
            notes = sing.split()
            song = []
            pitches = []
            # Gather notes and rests
            for note in notes:
                cNumber = cDict.get(note)
                if cNumber != None:
                    pitches.append(cNumber)
                elif note == '(rest)':
                    song.append(pitches)
                    pitches = []
            song.append(pitches)
            # Output beeps from computer.
            wait = self._noteLength / 1000.0
            for part in song:
                beepList(part, self._noteLength)
                time.sleep(wait)
            return
        return readSolfege_v2

    def translateButton(self):
        """
        Reads string from the first Entry widget.
        ToDo: set() the other 4 entry fields.
        """
        # Get string to be translated.
        text = self.userInput.get()
        if text == '': # Guardian.
            print('NO INPUT FOUND. Please enter text for translation.')
        else:
            print(text, 'will be translated into solfege.')

            # Caps locked list of strings.
            if (not self._caseSensitive):
                text2 = prepareStr(text)

            text3 = []
            # List of integer lists.
            # Values: 0 to 25.
            for word in text2:
                a = myStrToInt(word, 26)
                text3.append(a)
            print('Input Text in number format:', text3)

            # Replace other 4 Entry fields. Translates text3.
            a = 0
            for e in self.playVars:
                oldE = e.get()
                if oldE != '':
                    print('   ', oldE, 'will be replaced.')
                e.delete(0,END)
                scaleUsed = self._scaleInSolfege[a]
                result = iListsToSolfege(text3, scaleUsed)
                e.insert(0,result)
                a += 1
            print('Translation complete.')


def main():
    master = Tk()
    App(master) # Creates the app.
    # 'mainloop()' prevents the user from typing more
    #   prompts until the GUI closes.
    mainloop()

main()
