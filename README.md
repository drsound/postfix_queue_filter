# Postfix Queue Filter

Postfix Queue Filter is a Ruby script to search and possibly delete messages in Postfix mail queue. It's useful for example if an automatic procedure mistakenly sent a lot of emails and you want to get rid of them.

Arguments are the strings (default behaviour) or regular expressions (**-r** option) to be matched against enqueued message headers. All arguments must match for the message to be selected (AND logic).

**-h** option shows all of the headers of matched messages

**-d** option deletes matched messages from mail queue

## Usage example:

Search for messages from aaa@bbb.com to ccc@ddd.com and show all headers, to be sure you are going to delete the right messages:

`postfix_queue_filter.rb -h 'From: aaa@bbb.com' 'To: ccc@ddd.com'`

Delete those messages:

`postfix_queue_filter.rb -d 'From: aaa@bbb.com' 'To: ccc@ddd.com'`

## License

GNU General Public License v3.0, see LICENSE file

## Author

Alessandro Zarrilli (Firenze - Italy)  
alessandro@zarrilli.net
