Notes for **A Very Im-port-ant Topic, or Using Ports in the Real World**.
Each top-level bullet point is a section. Each section consists of one or more slides, but hopefully not more than a few.

- Title slide
- A quick definition of ports
- Addressing a misconception
    - Ports allow us to treat JS as a service, but they don't work like promises do.
    - Ports have an asynchronous API
    - Promises have a synchronous API
- Async Execution vs. Async API
	- Async/Sync Execution: Specifies whether or not the execution thread is blocked by a command
	- Async/Sync API: Specifies how the user interacts with some code entity, regardless of how commands are actually executed on the underlying thread.
- Async API vs. Sync API 
	- Sync API: Chain of actions
	- Async API: Messages out and messages in
- Real World Example:
	- We treat HTTP requests Synchronously
	- We treat Web sockets Asynchronously
- Why do ports have an Async API?
	- See Elm Town Episode 13
	- Ports are designed to be safe. Elm can make no guarantees about what Javascript will do in response to a message, so it makes none at all. All it can say is that it will send messages out, and might get messages in.
	- This API is a well-known design pattern sometimes called "the actor model", and can be found in technologies built for concurrency such as Erlang's Actors, Scala's Akka, and Web Workers, and more.
- When to use ports
- Addressing a misconception
	- Beginner Elm materials can make it seem like a new port should be used for each new action we want javascript to take. As soon as an app gets even a little bit complex, this could explode into a hairy mess of ports that are annoying to maintain.
	- Example: A client-side database. The initial approach might be to create a port for each operation (read Foo, create a Foo, update a Foo, get a Foo by id, get a Foo by some property, etc... )
