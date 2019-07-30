# DT Image Cropper

A simple Cocoapods library that allows a user to select an image and then crop it to a certain size

# Warning

This project is still under development and is by far not ready for use in an application.

# Done

1. The user can select an image from the photo libary
2. The user can move the cropping box using the top left hand corner.
3. The user can zoom and scroll to view the image - still restricted to some areas.

# TODO's

1. Validate if the device has access to the camera
2. Add top left, bottom left, top right, bottom right indicators on the crop zone to indicate to the user that they can move the box from there.
3. Add logic that checks which region of the cropping box the user has selected.
4. Add the coords of the image to the overlay so that the overlay knows its max boundaries.
5. Add a toolbar that allows for the user to confirm area selection or to cancel out of the cropper.
6. Add a public interface that the calling controller can use to retrieve the cropped image.
7. The scrolling and zooming of the image requires some attention to make sure that it is perfect for the user.
8. Add podspec etc. Not required until completed.