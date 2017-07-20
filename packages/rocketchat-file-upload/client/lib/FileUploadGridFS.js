/* globals FileUploadBase, UploadFS, FileUpload:true */
FileUpload.GridFS = class FileUploadGridFS extends FileUploadBase {
	constructor(meta, file, data) {
		super(meta, file, data);
		this.handler = new UploadFS.Uploader({
			store: Meteor.fileStore,
			data: data,
			file: meta,
			onError: (err) => {
				var uploading = Session.get('uploading');
				if (uploading != null) {
					let item = _.findWhere(uploading, {
						id: this.id
					});
					if (item != null) {
						item.error = err.reason;
						item.percentage = 0;
					}
					return Session.set('uploading', uploading);
				}
			},
			onComplete: (fileData) => {
				var file = _.pick(fileData, '_id', 'type', 'size', 'name', 'identify');

				file.url = fileData.url.replace(Meteor.absoluteUrl(), '/');

				Meteor.call('sendFileMessage', this.meta.rid, null, file, () => {
					Meteor.setTimeout(() => {
						var uploading = Session.get('uploading');
						if (uploading != null) {
							let item = _.findWhere(uploading, {
								id: this.id
							});
							return Session.set('uploading', _.without(uploading, item));
						}
					}, 2000);
				});
			}
		});
	}
	start() {
		return this.handler.start();
	}

	getProgress() {
		return this.handler.getProgress();
	}

	stop() {
		return this.handler.stop();
	}
};
