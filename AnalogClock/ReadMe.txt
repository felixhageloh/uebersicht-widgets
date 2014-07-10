--------------------------------------------------------------------------------
Widget: Analog Clock
Author: Chris Johnson
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
Features
--------------------------------------------------------------------------------
Multiple versions of the clock can be run at the same time, allowing one to have
  multiple timezones displayed.

The following options can be customized on the clock. 

  Timezone -- Any Unix timezone can be specified. With no timezone specified,
              it will default to the local timezone.
  
  Clock Size -- The clock can be scaled to any size.
  
  Clock Face -- The code-driven clock face can be customized as desired. Alternatively,
                a custom image can be used instead of (or in addition to the clock face).
                
  Hands -- The hands can be completely customized, including sizes, colors, etc.
  
  
--------------------------------------------------------------------------------
Clock Size/Scale
--------------------------------------------------------------------------------
Most of the features of the clock can be manipulated by changing the "Settings"
  objects (Clock, Face, etc.). Most of the settings are intuitive. Others are explained
  easily by making changes and looking at how they affect the clock.
  
  There are, however, a couple settings that require some explanation:
  
    Clock.size: 100
    Clock.scale: 2

    The overall size of the clock is determined by Size * Scale. This allows us
    to scale all of the elements on the clock as desired.
    
    Size is the baseline measurement, and Scale is applied to all heights/widths/etc. 
    on the clock.

--------------------------------------------------------------------------------
Changing Timezones
--------------------------------------------------------------------------------
  The timezones are set with the Unix command. For example:
  
    command: 'export TZ="US/Central";date +"%m/%d/%Y %I:%M:%S %p"'
  
  will show the clock in US Central time. If you wish to show the clock in another
  timezone, you can use any of the Unix-supported values (Valid values are relative to 
  /usr/share/zoneinfo) These can be found with the following shell command:
  
    find /usr/share/zoneinfo -type f
    
  If you wish to use your local timezone, you can simply eliminate the timezone
  from the command:
  
    command: 'date +"%m/%d/%Y %I:%M:%S %p"'

--------------------------------------------------------------------------------
Clock Face Image
--------------------------------------------------------------------------------
To display an image on the face of the clock, change the following two settings:

  Set FaceImage.filename to an image file in the clock's widget directory
  Set Clock.showFaceImage to true

