# Angular + Jasmine #

### Testing the Night Away ###

## Intro ##

[Jasmine](http://pivotal.github.io/jasmine/) is a great testing framework (like
that of [QUnit](http://qunitjs.com/) and
[Mocha](http://visionmedia.github.io/mocha/). Jasmine is the default testing
framework for Angular.js which also includes some helper methods within the
ng-mock module. This post should give you a brief overview of what Jasmine is,
how to use it, and how to leverage Angular.js's features to create
comprehensive, sane tests over your code.

## Jasmine ##

Jasmine is a testing framework that really leverages the idea of Behavior
Driven Development. This is the idea of testing overall functionality of pieces
of code without having deep knowledge of what is going on inside. Think of your
code as a black box, you know what goes in, you know what comes out (or you
think you do), so you write your tests with only this knowledge. Later, when
your implementation changes, but the inputs and outputs stay the same, your
tests are still valid!

Jasmine tests are written verbosely to tell a story. There are a few keywords
that do this well:

*  `describe`: Such as `describe('Testing of the Navbar Controller');`
*  `beforeEach`: Execute the following function before each test
*  `afterEach`: Execute the following function after each test
*  `it`: Such as `it('Logs an error when the $http request fails', function() {});`

## Jasmine + Angular.js ##

Angular.js provides some great helper functions in the global scope along with
some other helpers in `ng-mock`.

### angular.mock.dump ###

Angular provides to us a function named `dump` which allows us to log complex
objects to the console that are unable to be logged through console.log. The
main example of this is `$scope`. The scope variable is unable to be logged due
to a circular structure.

While debugging your tests or code, just insert `dump(someVariable)` and revel
in the goodness of it. You also get the scope's unique identifier, which can be
handy when tracing down whether or not you're modifying the correct scope or a
subscope.

### angular.mock.inject ###

`inject` is a globally available API to the Dependency Injection framework in
Angular. With it, you can ask for any injectable that has been loaded in from
the modules you have loaded in. This is very helpful as you can `spyOn` these
instances and mock out their functionality to give you a very controlled
environment to run your tests.

```javascript
describe("Example of using inject", function() {
  myObject = null;
  beforeEach(inject(function(_myObject_) {
    myObject = _myObject_;
    spyOn(myObject, ['someFunction']);
  }));
  it("should tell us if we called someFunction", function() {
    myObject.someFunction();
    expect(myObject.someFunction).toHaveBeenCalled();
  });
});
```

The above test will inject an instance of myObject, attach a spy to the
`someFunction` function on myObject and then the test will call it, and then
verify that the spy caught the call to the function.

### httpBackend ###

This service is a mock version of the real service behind $http in regular
angular.js code. By injecting `$httpBackend` you can let the service know
exactly how many calls to which endpoints you are expecting, and how to respond
to them. This means you can test any kind of server response and know exactly
what calls and how many you are making to the server.


