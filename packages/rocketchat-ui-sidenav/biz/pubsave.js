Template.pubsave.helpers({
	error() {
		return Template.instance().error.get();
	},
	welcomeMessage() {
		return '';
	}
});

Template.pubsave.events({
	'submit #pubsave'(e, instance) {
		e.preventDefault();
		var resName = instance.$('input[name=resName]').val();
		var resDesc = instance.$('#resDesc').val();
		var resUrl = instance.$('input[name=resUrl]').val();

		var resType = instance.$('select[name=resType]').val();
		var skill = instance.$('select[name=skill]').val();


		var publish = {
			resName: resName,
			resDesc: resDesc,
			resUrl: resUrl,
			resType: resType,
			skill: skill
		};


		Meteor.call ('savePublish', publish, function(error, results)
		{
			if (results) {
				toastr.remove();
				toastr.success ('发布学习资源成功')
			}
			if (error) {
				toastr.remove();
				handleError(error);
			}
		});

	},
	'click .error'(e, instance) {
		return instance.hideError();
	}
});

Template.pubsave.onCreated(function() {
	this.error = new ReactiveVar();
	this.showError = (msg) => {
		$('.error').addClass('show');
		this.error.set(msg);
	};
	this.hideError = () => {
		$('.error').removeClass('show');
		this.error.set();
	};
});
