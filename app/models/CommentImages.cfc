component extends=BaseImage accessors=true {
  property name='ci_ciid'      type='numeric'  sqltype='integer'    primary_key;
  property name='ci_bcoid'     type='numeric'  sqltype='integer';
  property name='ci_benid'     type='numeric'  sqltype='integer';
  property name='ci_beiid'     type='numeric'  sqltype='integer';
  property name='ci_usid'      type='numeric'  sqltype='integer';
  property name='ci_width'     type='numeric'  sqltype='integer'    default='0';
  property name='ci_height'    type='numeric'  sqltype='integer'    default='0';
  property name='ci_size'      type='numeric'  sqltype='integer';
  property name='ci_filename'  type='string'   sqltype='varchar';
  property name='ci_added'     type='date';
  property name='filefield'    type='string'                        default='comment_image';
  property name='file_rename'  type='string';

  belongs_to(name: 'BlogEntry',      class: 'BlogEntries',      key: 'ci_benid',  relation: 'ben_benid');
  belongs_to(name: 'BlogEntryImage', class: 'BlogEntryImages',  key: 'ci_beiid',  relation: 'bei_beiid');
  belongs_to(name: 'BlogComment',    class: 'BlogComments',     key: 'ci_bcoid',  relation: 'bco_bcoid');
  belongs_to(name: 'User',           class: 'Users',            key: 'ci_usid',   relation: 'us_usid');

  variables.image_size = 1200;
  variables.thumb_size = 256;
  variables.image_root = 'comment';

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'commentimages_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer',   value: arguments.get('ci_ciid'),     null: !arguments.keyExists('ci_ciid'));
    sproc.addParam(cfsqltype: 'integer',   value: arguments.get('ci_bcoid'),    null: !arguments.keyExists('ci_bcoid'));
    sproc.addParam(cfsqltype: 'integer',   value: arguments.get('ci_benid'),    null: !arguments.keyExists('ci_benid'));
    sproc.addParam(cfsqltype: 'integer',   value: arguments.get('ci_beiid'),    null: !arguments.keyExists('ci_beiid'));
    sproc.addParam(cfsqltype: 'integer',   value: arguments.get('ci_usid'),     null: !arguments.keyExists('ci_usid'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);
    return sproc.execute().getProcResultSets().qry;
  }

  // PRIVATE

  // private void function delete_image(required string filefield) {
  //   var field = find_field(arguments.filefield);
  //   if (field.isEmpty()) return;

  //   try {
  //     if (fileExists(local_path() & image_name())) {
  //       fileDelete(local_path() & image_name());
  //       utility.fileDeleteS3(remote_src() & image_name());
  //     }
  //     if (fileExists(local_path() & thumbnail_name())) {
  //       fileDelete(local_path() & thumbnail_name());
  //       utility.fileDeleteS3(remote_src() & thumbnail_name());
  //     }
  //     return;
  //   } catch (any err) { }
  //   errors().append('Could not delete #image_name()#.');
  // }

  // private string function image_name() {
  //   return utility.hashCC(ci_ciid) & '.jpg';
  // }

  // private string function local_path() {
  //   return application.paths.images & 'comment\'  & ci_bcoid % 10 & '\';
  // }

  // private any function make_thumbnail(required any img) {
  //   var zoom = 1.05; // trim some edge from thumbnail
  //   var max = thumb_size * zoom;
  //   var info = ImageInfo(img);
  //   if (info.height > info.width) {
  //     img.resize(max, '');
  //   } else if (info.width >= info.height) {
  //     img.resize('', max);
  //   }
  //   info = ImageInfo(img);
  //   var pos_x = (info.width - thumb_size) / 2;
  //   var pos_y = (info.height - thumb_size) / 2;
  //   img.crop(pos_x, pos_y, thumb_size, thumb_size);
  //   return img;
  // }

  // private struct function move_final(required string filename) {
  //   var img = utility.orient_image(ImageRead(filename));
  //   var info = ImageInfo(img);
  //   if (info.height > image_size || info.width > image_size) { // ENFORCE MAX DIMENSION
  //     img.scaleTofit(image_size, image_size);
  //     info = ImageInfo(img);
  //   }
  //   cfimage(action: 'write', source: img, destination: local_path() & image_name(), quality: 1, overwrite: 'true');
  //   info.append(GetFileInfo(local_path() & image_name()));
  //   img = make_thumbnail(img);
  //   cfimage(action: 'write', source: img, destination: local_path() & thumbnail_name(), quality: 1, overwrite: 'true');
  //   // COPY TO S3
  //   utility.fileCopyS3(local_path() & image_name(), remote_src() & image_name());
  //   utility.fileCopyS3(local_path() & thumbnail_name(), remote_src() & thumbnail_name());

  //   return info;
  // }

  // private string function remote_path() {
  //   return application.urls.images & '/comment/'  & ci_bcoid % 10 & '/';
  // }

  // private string function remote_src() {
  //   return application.s3.bucket & remote_path();
  // }

  // private void function post_destroy(required boolean success) {
  //   if (!success) return;
  //   delete_image('ci_filename');
  // }

  // private void function post_insert(required boolean success) {
  //   if (!success) return;
  //   upload_image();
  // }

  // private void function pre_insert() {
  //   try {
  //     if (len(form.get(variables.filefield))==0) {
  //       errors().append('Image Missing');
  //       return;
  //     }

  //     if (isSimpleValue(form[variables.filefield])) {
  //       var path = form[variables.filefield];
  //       if (!fileExists(path)) {
  //         return errors().append('Could not upload #variables.upload_result.clientFile#.');
  //       }
  //       variables.upload_result = {
  //         fileWasSaved:  true,
  //         clientFile:    getFileFromPath(path),
  //         serverFile:    getFileFromPath(path),
  //         serverDirectory: getDirectoryFromPath(path)
  //       }
  //     } else {
  //       var tmpDir = application.paths.root & 'tmp';
  //       setting requesttimeout=90 showdebugoutput='no'; // IMAGE PROCESSING TAKES EXTRA TIME
  //       cffile(action: 'upload', filefield: variables.filefield, destination: tmpDir, result: 'variables.upload_result', nameconflict: 'overwrite');
  //       if (!upload_result.fileWasSaved) {
  //         return errors().append('Could not upload #variables.upload_result.clientFile#.');
  //       }
  //     }

  //     var local_file = upload_result.serverDirectory & '\' & upload_result.serverfile;
  //     if (!isImageFile(local_file)) {
  //       fileDelete(local_file);
  //       errors().append('File is not a valid image. Please pick another.');
  //     }
  //   } catch (any err) {
  //     errors().append(utility.errorString(err));
  //   }
  // }

  // private string function thumbnail_name() {
  //   return utility.hashCC(ci_ciid) & '_tn.jpg';
  // }

  // private void function upload_image() {
  //   try {
  //     if (variables.upload_result.fileWasSaved) {
  //       var filename = variables.upload_result.serverDirectory & '\' & variables.upload_result.serverfile;
  //       if (!directoryExists(local_path())) cfdirectory(action: 'create', directory: local_path(), mode: 644);
  //       param variables.ci_filename = utility.slug(variables.upload_result.clientfile);
  //       var info = move_final(filename);
  //       variables.ci_height = info.height;
  //       variables.ci_width = info.width;
  //       variables.ci_size = info.size;
  //       update_db();
  //     }
  //   } catch (any err) {
  //     errors().append(utility.errorString(err));
  //   }
  // }
}