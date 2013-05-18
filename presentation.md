# Angular.js + Jasmine #

### Testing the Night Away ###

Chris Moultrie

[@tebriel](https://twitter.com/tebriel) [GitHub](https://github.com/tebriel)

[![Endgame](/img/endgame.jpg)](http://www.endgame.com)


## Topics ##

*  Basic [Jasmine](http://pivotal.github.io/jasmine/) Overview
*  [Karma](http://karma-runner.github.io/)
*  Loading Modules
*  Dependency Injection
*  Controller Construction
*  ngMock
  *  [$httpBackend](http://docs.angularjs.org/api/ngMock.$httpBackend)
  *  [$log](http://docs.angularjs.org/api/ngMock.$log)
  *  [$timeout](http://docs.angularjs.org/api/ngMock.$timeout)
  *  [dump](http://docs.angularjs.org/api/angular.mock.dump)



## Jasmine ##

![Jasmine](/img/jasmine.jpg)

*  BDD Framework (Fits well into TDD as well)
*  Simple ideas, lots of expandability
*  Angular's Default Testing Framework


## [B|T]DD ##

*  Used to test as you develop
*  Commit any sins necessary
*  Live for the GREEN


### BDD ###

*  Tells a Story
*  Test the 'intent' of the code
*  Avoid having _deep knowledge_ of code being tested
*  Change to implementation should not affect test


### TDD ###

*  Test functionality on a micro-level
*  Use deep knowlege to test all code paths
*  Implementation change typically breaks test


## Basic Jasmine Example ##

```coffeescript
describe "A Suite of Tests", ->
  beforeEach ->
    some.setup()
    @myVar = true

  afterEach ->
    some.teardown()

  it "Verifies that we did some setup", ->
    expect(@myVar).toBeTruthy()
```


## Jasmine Matchers ##

*  functions on the object that `expect` returns
*  object equality: `.toEqual()`
*  truthiness/falsiness: `.toBeTruthy()`/`.toBeFalsy()`
*  Array Contains: `.toContain('abc')`
  *  ['def', 'abc', '123']

*  Fuzzy value matching
  *  `.toBeGreaterThan()`/ `.toBeLessThan()`
  *  `.toBeCloseTo()`
*  `jasmine.Any()`


## Jasmine Spies ##

### Creating ###

*  `spyOn()`
*  `createSpy()` && `createSpyObj()`

### Using ###

*  `.andCallThrough()`
*  `.andReturn()`
*  `.andCallFake()`


## (Mostly) Unnecessary in Angular.js ##

*  Mock Clock (`$timeout` in Angular.js)
*  Async Support (`$httpBackend` solves most of this)



## Karma ##

*  Framework Agnostic TestRunner
*  Allows code testing in multiple browsers
*  Integrates with PhantomJS (great for background test running)
*  Great for CI Servers (like [Jenkins](http://jenkins-ci.org/) or [Travis](https://travis-ci.org/))
*  Add a grunt task via [grunt-karma](https://npmjs.org/package/grunt-karma)


## Config ##

```javascript
basePath = '../';

files = [
    JASMINE,
    JASMINE_ADAPTER,
    'static/src/vendor/angular/angular-*.js',
    'static/js/code.min.js',
    'static/js/spec.min.js'
];

autoWatch = true;

reporters = ['progress']

browsers = ['PhantomJS'];
```


## Loading Modules in Angular.js ##


```coffeescript
describe "Navbar Testing", ->
    beforeEach module("EG.navbar")
```






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



## Demo ##

Let's take a look at the <a href="/docs/app.html" target="_blank">documentation</a>



### Questions? ###
