/* global renderMessageBody:true */
/* exported renderMessageBody */

var singleEmojiCheck;

renderMessageBody = function(msg) {
	var message;

	msg.html = msg.msg;

	if (_.trim(msg.html) !== '') {
		msg.html = _.escapeHTML(msg.html);
	}

	message = RocketChat.callbacks.run('renderMessage', msg);

	if (message.tokens && message.tokens.length > 0) {
		for (let {token, text} of message.tokens) {
			message.html = message.html.replace(token, () => text); // Uses lambda so doesn't need to escape $
		}
	}

	msg.html = message.html.replace(/\n/gm, '<br/>');

	if (singleEmojiCheck(msg)) {
		msg.html = (msg.html).replace('emojione ', 'big_emojione ');
	}

	return msg.html;
};

/**
 *Checks to see if a message contains only an emoji span
 *@para {msg} some html message
 *@return {false} the html message either doesn't
 *contain an emoji span, or contains other characters
 */
singleEmojiCheck = function(msg) {
	var str = msg.html;
	str = str.trim();

	//checks to make sure it's a span
	if (!str.includes('<') || !str.includes('>')) {
		return false;
	}

	if (str.charAt(0) !== '<' || str.charAt(str.length - 1) !== '>') {
		return false;
	}

	if (str.indexOf('>') === str.lastIndexOf('>')) {
		return false;
	}

	//checks to make sure it's the only span
	str = str.substring(str.indexOf('<') + 1, str.lastIndexOf('>') - 1);
	if (!str.includes('<') || !str.includes('>')) {
		return false;
	}

	if (str.indexOf('<') < str.lastIndexOf('>')) {
		return false;
	}

	return true;
};

