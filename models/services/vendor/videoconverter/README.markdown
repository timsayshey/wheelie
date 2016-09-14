Video Converter
=============

Video Converter can be used to convert your videos to and from several video formats.

Initialization
-------

To initialize VideoConverter, you must first have FileMgr (included instantiated).

FileMgr must be initialized using the "init" method, which takes two arguments:

* UploadPath: The server path to the folder to which files will be uploaded or stored.
* UploadURL: The URL to the UploadPath

FileMgr itself is the only required argument for VideoConverter. So, assuming that you place the "video_converter" folder in the root of your site, this would be the initialization code:

	Application.FileMgr = CreateObject("component","video_converter.FileMgr").init(ExpandPath("/f/"),"/f/");
	Application.VideoConverter = CreateObject("component","video_converter.VideoConverter").init(Application.FileMgr);

This would put files in the "/f/" folder of your site, but you could change those arguments to any location you would like.

Convert Video
-------

Video conversion is done using the "convertVideo" method, which takes the following arguments:

* VideoFilePath: The absolute file path to the video that needs to be converted.
* Folder: The folder (within FileMgr's UploadPath) in which to place the resulting file.
* Extension: The file extension for the resulting file (from which Video Converter will determine the video encoding)


Create Thumbnail
-------

Video Converter can create a thumbnail from a video using the "generateVideoThumb" method, which takes the following arguments:

* VideoFilePath: The full path to the video from which a thumbnail image will be created.
* ThumbFolder: The folder in which to place the resulting thumbnail image.


Get Video Information
-------

To get file metadata from a video, use the "getVideoInfo" method with the following arguments:

* file: The full path to the video.

Video Player HTML
-------

Video Converter can create HTML to play the video(s) universally (using the "Video For Everybody" code) using the getVideoHTML() method, which takes the following arguments:

* VideoFiles: A list of URLs to the video files that should be played.
* Width (optional): The width of the video
* Height (optional): The height of the video
* Title (default:"video"): A title for the video
* Controls (default:true): Boolean indicating whether video controls should display
* AutoPlay (default:true): Boolean indicating whether video the video should play automatically (default subject to change)

Note that the video should ideally be available as all of the following formats:

* AVI
* FLV
* MP4
* OGV
* WEBM

All of which Video Converter can convert videos into.


Extra Records.cfc Methods
-------

Video Converter also has extra functionality for use with Records.cfc which will be documented "soon".