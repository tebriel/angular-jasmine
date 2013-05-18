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

[![Jasmine](/img/jasmine.jpg)](http://www.fanpop.com/clubs/disney-princess/images/29762439/title/princess-jasmine-photo)

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

```javascript
describe("A Suite of Tests", function() {
  beforeEach( function() {
    some.setup();
    this.myVar = true;
  });

  afterEach( function() {
    some.teardown();
  });

  it("Verifies that we did some setup", function() {
    expect(this.myVar).toBeTruthy();
  });
});
```


## Cool Jasmine Features ##

*  Matchers
*  Spies
*  Mock Clock
*  Async Tests


## Jasmine Matchers ##

*  functions on the object that `expect` returns
*  object equality: `.toEqual()`
*  truthiness/falsiness: `.toBeTruthy()`/`.toBeFalsy()`
*  Array Contains: `.toContain('abc')`
  *  ['def', 'abc', '123']

*  Fuzzy value matching
  *  `.toBeGreaterThan()`/ `.toBeLessThan()`
  *  `.toBeCloseTo()`
*  `jasmine.any()`
  *  Number
  *  Object
  *  Function


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

[![Lotus](/img/lotus.jpg)](http://en.wikipedia.org/wiki/File:Sacred_lotus_Nelumbo_nucifera.jpg)

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


## Preprocessors ##

Karma can do some cool preprocessing like analyzing code coverage with Istanbul
or auto-compile coffeescript before running the tests.


## Debug Mode ##

Let's go look at that real quick.

<a href='http://localhost:9876' target='_blank'>DEMO</a>



## Let's talk Angular ##

[![Angular](/img/angular.png)](http://angularjs.org/)


## Bootstraping your Tests ##

*  Load the module needed
*  Ask for your dependencies
*  Spy on your dependencies
*  Construct your controller


## Loading Modules in Angular.js ##

It's so simple!

Load up whatever module you're about to test

```javascript
describe("Navbar Testing", function() {
    beforeEach module("EG.navbar");
});
```

`module()` calls out to angular to pull in the module you want plus any
dependencies.


## Dependency Injection ##

```javascript
describe('Timeline Controller', function() {
    beforeEach( inject( function($rootScope, $controller) {
        this.scope = $rootScope.$new()
        this.controller = $controller;
    });
});
```

This works for any dependency that is available after loading your module(s),
even ones you've created and registered as a factory.


## Mocks and Spies ##

[![SpyVsSpy](/img/spy.jpg)](http://kurosama-76.deviantart.com/art/SPY-VS-SPY-336695133)


## Mocks with Dependency Injection ##

Inject within beforeEach is a great time to set up some spies.

```javascript
beforeEach(inject( function($rootScope, $controller) {
    this.scope = $rootScope.$new();
    spyOn(this.scope, '$emit');
    this.controller = $controller;
});

it("Emits 'reposition' whenever the alert is opened", function() {
    var controller = this.controller('AlertInfoCtrl', {$scope:this.scope});
    this.scope.toggleOpen();
    expect(this.scope.$emit).toHaveBeenCalledWith('reposition');
});
```

Now every time we create a controller with our `@scope` our spy will be hanging
in the shadows listening for calls to `$emit`


## Controller Construction ##

```javascript
var NavbarCtrl = function($scope, $http, $log, mapService) {
    // Some Logic goes here
    $scope.scrollMap = function(direction) {
        mapService.scrollLeft();
    }
});

angular.module('EG.navbar', ['EG.navbar.directives']) 
    .controller('NavbarCtrl', ['$scope', '$http', '$log', 'mapService', NavbarCtrl]);
```

```javascript
beforeEach(inject(function($rootScope, $controller) {
    this.scope = $rootScope.$new();
    this.controller = $controller;
    this.mapService = jasmine.createSpyObj('mapService', ['resize', 'scrollLeft', 'scrollRight']);
});

it("Emits 'reposition' whenever the alert is opened", function() {
    var controller = this.controller('NavbarCtrl',
        {$scope:this.scope, mapService:this.mapService});
    this.scope.scrollMap('left');
    expect(this.mapService.scrollLeft).toHaveBeenCalled();
});
```


## Angular Magic ##

We only manually provided `$scope` and `mapService`, Angular's DI service filled in
the rest of the gaps.

Angular will not provide `$scope`, you must provide that yourself, everything
else that it has, it will provide.

By injecting the `$controller` service you can ask Angular to construct any
controller it knows about, but using your own spies.



## ngMock Extra Special Objects ##

*  $httpBackend
*  $log
*  $timeout
*  angular.mock.dump


## $httpBackend ##

Testing web calls sucks, so no one does it. Thankfully with Angular's DI
service and the $http service our async web calls are crazy easy to test.

Another advantage of using the $http service is that Angular is promise aware,
so it knows when your request is done and will then run a `$digest/$apply`
across your scope to update anyone watching variables in scope


Consider the following Controller:

```javascript
var NavbarCtrl = function($scope, $http, $log) {
    success = function(data, status, headers, config) {
        // If we don't have data, bail
        if (data == null) {
            $log.error("Issue with data", data, status, headers, config);
            return;
        }

        // Save the current chats
        $scope.currentChats = data;
    }
                
    // If things go horribly wrong, we should tell someone, but don't ask me,
    // I'm not in charge here.
    fail = function(data, status, headers, config) {
        $log.error("ChatsError", data, status, headers, config);
    }

    $http.get("api/chats").success(success).error(fail);
}
```


To Test: 

```javascript
describe("NavbarCtrl", function() {
    beforeEach(inject(function($controller, $rootScope, $httpBackend) {
        this.httpBackend = $httpBackend;
        this.scope = $rootScope.$new();
        this.controller = $controller;
    }));

    it("Creates a navbar controller", function() {
        var expected = {test: true};
        this.httpBackend.expectGET('api/chats')
            .respond(expected);
        var controller = this.controller('NavbarCtrl', {$scope:this.scope});
        this.httpBackend.flush();
        expect(this.scope.currentChats).toEqual(expected);
    });
});
```

Now we have control over when the response fires and what the response is.


## $log ##

`console.log` is ugly when testing. You have to wade through a whole bunch of
lines that just muck up your reporter's status. `$log` wraps `console.log` for you
(and `.error`, `.info`, etc).


## $log ##

When using `ngMock` a mock version of `$log` is automatically injected instead
of the regular one. This is great for a few reasons.

1.  No more mucking up the console where your test runner is
1.  You can ask `$log` how many and what messages were logged. This can be
    another test.
1.  You can actually see what was logged, especially if you want to test that a
    specific message was logged to a logger.


Example:

```javascript
describe("NavbarCtrl", function() {
    beforeEach(inject(function($controller, $rootScope, $httpBackend, $log) {
        this.httpBackend = $httpBackend;
        this.scope = $rootScope.$new();
        this.log = $log;
        this.controller = $controller;
    }));

    it("Creates a navbar controller", function() {
        var expected = {test: true};
        this.httpBackend.expectGET('api/chats')
            .respond(expected);
        var controller = this.controller('NavbarCtrl', {$scope:this.scope});
        this.httpBackend.flush();
        // If we have errors, something was unexpected!
        expect(this.log.error.logs.length).toEqual(0);
    });
});
```


## $timeout ##

Often we use `window.setTimeout` to postpone a task to run at a later time.
Angular provides the $timeout service which follows the promise model like that
used with $http.

Benefits of $timeout:

1.  Provides a `cancel()` method on the returned object
1.  Will do scope dirty checks after $timeout has returned
1.  Has its own mock!


## ngMock's $timeout ##

**Almost** the same as $timeout, except it adds `flush()`. This is just like
`$httpBackend.flush()` in that all calls can then be synchronously run without
needing callbacks or async testing code. 


## angular.mock.dump ##

Ever tried to JSON.stringify a scope object? Test runner can't do it.

Consider the following:

```javascript
console.log(JSON.stringify(this.scope));

TypeError: JSON.stringify cannot serialize cyclic structures.
```

Better:
```javascript
dump(this.scope);

PhantomJS 1.9 (Mac) LOG: """  Scope(00E): {\n    
  currentChats: {"unread":0}\n    chatsUnread: ""\n  }"""
```



### Questions? ###


ALL GLORY TO THE HYPNOTOAD

[![All Glory to the Hypnotoad](img/hypnotoad.gif)](http://buffalobeast.com/futurama-still-doesnt-suck/hypnotoad/)
