# endchat #

### Persistent Chat Framework ###

Created by Philip Thrasher and Chris Moultrie

Designed by Anne Harper


## Purpose ##

*  Persistent Message history across logins
  *  Ability to gain context from missed conversations
  *  Ability to remember what was decided previously in a conversation
*  Exploration of implementation for Velocity
*  Exploration of [Angular.js](http://angularjs.org) Framework



## Technologies Used ##

*  **Node.js** (server-side javascript)
*  **node-xmpp** (xmpp library for node.js)
*  **Socket.io** (asynchronous real-time communication)
*  **Sequelize.js** (node.js ORM)
*  **Express.js** (server-side web framework for node.js)
*  **CoffeeScript** (language that compiles to javascript)
*  **AngularJS** (client-side web framework from google)
*  **jQuery** (client-side helper library)
*  **Twitter Bootstrap** (css framework from twitter offering base styling to start
  from)



## Server's Role ##

*  Proxy chat messages from the web browser to a remote chat network.
*  Proxy chat messages from the remote chat network to the web browser.
*  Handle opening and maintaining connections to remote chat network for a
   connected user.
*  Maintain and fetch information from the remote chat network.
   *  Buddy list
   *  Room list
   *  Who's in which rooms?
*  Persistently store messages exchanged in chat rooms to a backing data store.


### Remote Chat Network ###

*  For endchat we chose XMPP.
*  XMPP connection manager is written as an "adapter"
  *  Can be easily swapped out with a connection manager for a different
     protocol (irc, oscar, etc...)
  *  Browser facing code gets locked down API to work from.


### Persistent History ###

**Benefits**

*  No longer wonder what was going on before you entered the conversation
*  "Why did we decide that?"
*  Even though someone is offline, can be notified that they were involved in a
   conversation


### History Storage ###

* History stored in postgres db.
* History captured for rooms only, not with private (1 on 1) chats.
* Messages de-duped by hash based on message timestamp, author, and message
  body.


### History Presentation ###

The app pre-fills the chat area with the most recent history for the user to
gain immediate context of what is going on.

The app will fetch more messages as user scrolls to earlier positions in the
history.



## Demo ##

Let's take a look at <a href="/#login" target="_blank">endchat</a>



## Velocity Implementation ##

*  Velocity is expected to have chat with:
  *  Rooms
  *  Buddies
  *  Messages


### Reusable Components ###

*  Server to handle web connections to talk to chat server
*  Web components for talking to server
*  Web templates for presenting chat data to user


### Lessons Learned ###

* XMPP is not a simple protocol.
* Chat is not as simple as it seems from the outset.
* CoffeeScript and Angular.js reduce the number of lines of code by an order of
  magnitude.



## Angular.js Framework ##

Project was written using Angular.js as the web layer for presenting the user
interface.


### Directives ###

Directives handle code that is written specifically manipulate the DOM.

```coffeescript
popoverDirective = ($rootScope) ->
    restrict: 'E'
    replace: false 
    link: (scope, iElement, iAttrs) ->
        $rootScope.$on 'liUpdate', ->
            # Wait until after we've rendered the element
            setTimeout ->
                $('.user-item', iElement[0]).popover()
            , 100
```


### Controllers ###

Controllers handle business logic which deal with data to be presented to the
view.


### Chat History Controller Snippet ###

```coffeescript
@ChatHistoryCtrl = ($rootScope, $scope, $filter, socket) ->
    $scope.templateUrl = 'partials/chathistory.html'
    $scope.chatTitle = ''

    # Remove the cruft from the username
    $scope.cleanUsername = (nick) ->
        return unless nick?
        return nick.split('@')[0]

    # Wait for root scope to send us the room information
    $rootScope.$watch 'currentRoom', (newRoom, oldRoom) ->
        return unless newRoom?
        $scope.chatTitle = newRoom.title
        # Request the room's message history
        socket.emit 'get-history',
            limit: 100
            ident: newRoom.ident
```


### Partials/Templates ###

    <div class='menu-section'>
        <ul class='unstyled buddies' flexheight='-179'>
            <li ng-repeat="buddy in buddies | orderBy:nickPredicate | filter:{state: '!offline'}"
                ng-click='clickBuddy(buddy)'
                class='user-item'
                data-toggle="popover"
                data-trigger='hover'
                data-title='{{buddy.nick}}'
                data-content='{{buddy.ident}}' >
                <div class='status {{buddy.state}}'></div>&nbsp;
                <span class='nickname'>{{buddy.nick}}</span>
            </li>
        </ul>
    </div>



### Benefits of Angular.js ###

*  Testability
  *  Unit Tests
  *  End-to-End Tests
*  Separation of Business Logic and Presentation Layer
*  Growing Community
*  Many channels for help
*  Google is behind the framework, so unlikely to disappear any time soon


### Negatives of Angular.js ###

*  Tough learning curve (new way of thinking)
*  Plugin community is just starting (have to write our own for some things)
*  Documentation is incomplete/fuzzy in some areas
*  Porting code from current framework is possible, but with moderate effort


### Final Opinion on Framework ###

*  Absolutely the way we should go for V2
*  Negatives are small compared to the benefits from:
  *  Testability
  *  Separation of Concerns
*  Support on IRC and Mailing list is prompt and very helpful



## Documentation with Docco ##

*  Comments become documentation with [docco](http://jashkenas.github.io/docco/)
*  Build task creates documentation automatically


## Demo ##

Let's take a look at the <a href="/docs/app.html" target="_blank">documentation</a>



## Final Comments ##

*  Many reusable parts
*  Gained a strong understanding of Angular.js which will help in V2
*  Things we wanted to do but didn't have enough time:
   *  Support for @mentions with email notification for offline users.
   *  Support for showing pasted image links as images inline in the chat.
   *  File sharing.
*  All code up on internal github (https://git.endgames.local/cmoultrie/endchat)



### Questions? ###
