Meteor.startup(function() {
	RocketChat.settings.addGroup('Livechat');

	RocketChat.settings.add('Livechat_enabled', false, { type: 'boolean', group: 'Livechat', public: true });

	RocketChat.settings.add('Livechat_title', 'Rocket.Chat', { type: 'string', group: 'Livechat', public: true });
	RocketChat.settings.add('Livechat_title_color', '#C1272D', { type: 'color', group: 'Livechat', public: true });

	RocketChat.settings.add('Livechat_offline_title', 'Leave a message', {
		type: 'string',
		group: 'Livechat',
		public: true,
		section: 'Offline',
		i18nLabel: 'Title'
	});
	RocketChat.settings.add('Livechat_offline_title_color', '#666666', {
		type: 'color',
		group: 'Livechat',
		public: true,
		section: 'Offline',
		i18nLabel: 'Color'
	});
	RocketChat.settings.add('Livechat_offline_message', 'We are not online right now. Please leave us a message:', {
		type: 'string',
		group: 'Livechat',
		public: true,
		section: 'Offline',
		i18nLabel: 'Instructions',
		i18nDescription: 'Instructions_to_your_visitor_fill_the_form_to_send_a_message'
	});
	RocketChat.settings.add('Livechat_offline_email', '', {
		type: 'string',
		group: 'Livechat',
		i18nLabel: 'Email_address_to_send_offline_messages',
		section: 'Offline'
	});

	RocketChat.settings.add('Livechat_registration_form', true, { type: 'boolean', group: 'Livechat', public: true, i18nLabel: 'Show_preregistration_form' });
	RocketChat.settings.add('Livechat_guest_count', 1, { type: 'int', group: 'Livechat' });

	RocketChat.settings.add('Livechat_Room_Count', 1, {
		type: 'int',
		group: 'Livechat',
		i18nLabel: 'Livechat_room_count'
	});

	RocketChat.settings.add('Livechat_Knowledge_Enabled', false, {
		type: 'boolean',
		group: 'Livechat',
		section: 'Knowledge Base',
		public: true,
		i18nLabel: 'Enabled'
	});

	RocketChat.settings.add('Livechat_Knowledge_Apiai_Key', '', {
		type: 'string',
		group: 'Livechat',
		section: 'Knowledge Base',
		public: true,
		i18nLabel: 'Apiai_Key'
	});

	RocketChat.settings.add('Livechat_Knowledge_Apiai_Language', 'en', {
		type: 'string',
		group: 'Livechat',
		section: 'Knowledge Base',
		public: true,
		i18nLabel: 'Apiai_Language'
	});
});
