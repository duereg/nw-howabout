GS = require 'grooveshark-streaming'
ytdl = require 'ytdl'
request = require 'request'
fs = require 'fs'


howaboutServices.factory 'PlayInfoSharedService', [
  '$rootScope'
  'PlayInfo'
  ($rootScope, PlayInfo) ->

    getStreamUrl = (track, callback) ->
      playInfo = PlayInfo.get
        trackTitle: track.trackTitle
        artistName: track.artistName
      ,
        ->
          if not playInfo.groovesharkSongID?
            return ytdl.getInfo playInfo.youtubeMovieUrl, (err, youtubeInfo) ->
              return callback err  if err?
              return callback new Error 'no youtubeInfo.formats'  if not youtubeInfo?.formats?

              for format in youtubeInfo.formats
                if format.itag is '18'
                  streamUrl = format.url
                  break

              if not streamUrl?
                return callback new Error 'no youtube itag 18 streamUrl'

              callback null, streamUrl, playInfo.lyrics

          GS.Grooveshark.getStreamingUrl playInfo.groovesharkSongID, (err, streamUrl) ->
            return callback err  if err?
            return callback new Error 'no grooveshark streamUrl'  if not streamUrl?

            callback null, streamUrl, playInfo.lyrics

    sharedService =
      streamUrl: null
      lyrics: null
      track: null

      playTrack: (track) ->
        getStreamUrl track, (err, streamUrl, lyrics) =>
          if err?
            $('#modalBodyMessage').html "Free source not found.<br />#{track.trackTitle} - #{track.artistName}"
            $('#alertDialog').modal 'show'
            return

          @streamUrl = streamUrl
          @lyrics = lyrics
          @track = track
          @broadcastPlayInfo()


      downloadTrack: (track, filePath) ->
        $('#modalBodyMessage').html "Search for a free source to download.<br />#{track.trackTitle} - #{track.artistName}"
        $('#alertDialog').modal 'show'

        getStreamUrl track, (err, streamUrl) ->
          if err?
            $('#modalBodyMessage').html "Free source not found.<br />#{track.trackTitle} - #{track.artistName}"
            $('#alertDialog').modal 'show'
            return

          streamRequest = request
            url: streamUrl
          fileStream = fs.createWriteStream filePath
          streamPipe = streamRequest.pipe fileStream

          fileStream.on 'finish', ->
            $('#modalBodyMessage').html "Download Complete.<br />#{track.trackTitle} - #{track.artistName}"
            $('#alertDialog').modal 'show'
          fileStream.on 'error', ->
            $('#modalBodyMessage').html "Download Failed.<br />#{track.trackTitle} - #{track.artistName}"
            $('#alertDialog').modal 'show'


      broadcastPlayInfo: ->
        $rootScope.$broadcast 'onBroadcastPlayInfo'

]
