
$(function () {
  var uploader = new plupload.Uploader({
    url: 'xhr.cfm?p=blog/image/upload',
    filters: {
      chunk_size: '1mb',
      mime_types: [
        { title: 'Image files', extensions: 'jpg,gif,png' }
       ]
    },
    views: {
      list: true,
      thumbs: true, // Show thumbs
      active: 'thumbs'
    },
    max_file_size: '10mb',
    file_data_name: 'ui_filename',
    headers: { 'X-Requested-With': 'XMLHttpRequest' },
    chunks: { size: '1mb' },
    rename: true,
    dragdrop: false,
    multiple_queues: false,
    multi_selection: false,
    prevent_duplicates: true,
    runtimes: 'html5,silverlight,html4',
    silverlight_xap_url : 'http://rawgithub.com/moxiecode/moxie/master/bin/silverlight/Moxie.cdn.xap',
    browse_button: 'btnFilePick', // you can pass an id...
    container: document.getElementById('container'), // ... or DOM Element itself
    init: {
      PostInit: function () {
        document.getElementById('filelist').innerHTML = '';
        document.getElementById('btnFileUpload').onclick = function () {
          // uploader.setOption('multipart_params', data);
          uploader.start();
          return false;
        };
      },
      BeforeUpload: function(up) {
        if (!loginPing()) window.location.reload();
        return true;
      },
      Error: function (up, err) {
        document.getElementById('console').innerHTML += '\nError #' + err.code + ': ' + err.message;
      },
      FilesAdded: function (up, files) {
        plupload.each(files, function (file) {
          document.getElementById('filelist').innerHTML += '<div id="' + file.id + '">File Selected: ' + file.name + ' (' + plupload.formatSize(file.size) + ') <i></i></div>';
          if (file) {
            let reader = new FileReader();
            reader.onload = function(event){
              console.log(event.target.result);
              $('#imgPreview').attr('src', event.target.result);
            }
            reader.readAsDataURL(file.getSource());
          }
        });
      },
      FileUploaded: function (up, file, result) {
        document.getElementById(file.id).getElementsByTagName('i')[0].innerHTML = 'Upload complete.';
        if (up.total.queued==0) location.reload();
      },
      UploadProgress: function (up, file) {
        document.getElementById(file.id).getElementsByTagName('i')[0].innerHTML = `${file.percent}%`;
      }
    }
  });

  uploader.init();
});
