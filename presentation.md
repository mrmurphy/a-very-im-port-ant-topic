autoscale: true

# A Very Im-port-ant Topic

Murphy Randle ([@splodingsocks](https://twitter.com/splodingsocks))

---

# What we're about to talk about

---

# Ports

A common problem:

> I need to do thing X, but there isn’t any package available on package.elm-lang.org that does it, and I [don’t have time to write it myself | can’t because it requires native javascript code]. There is a library on NPM that does it, though, how can I take advantage of that?

---
# Ports

The solution*:
*(almost always)

Use a port.

---

> Ports allow type-checked asynchronous communication between Javascript and Elm
> ~ Murphy Randle

---
# Ports

Three important attributes of ports:

1. Communication
2. Type-checking
3. Asynchronous API

---

# 1. Communication

Here's what ports look like:

```elm
-- Elm to JS
-- Send a word out to javascript to be spell-checked.
port getSuggestions : {word: String} -> Cmd msg

-- JS to Elm
-- Listen for suggestions of correct word spellings.
port suggestions : ({word: String, suggestions: List String} -> msg) -> Sub msg

-- (examples modified from guide.elm-lang.org)
```

--- 

# 2. Asynchronous API

---

# 2.1. Async Vs Sync

Here it is, short and sweet:

- Synchronous APIs are for defining a **sequence of events**
- Asynchronous APIs are for firing off and reacting to **single events**

---

# 2.1. Async Vs Sync

## Sync vs async in jokes

---

# 2.1. Async Vs Sync

Knock-knock jokes are synchronous.

> Knock-knock
> Who’s there?
> Recursion
> Recursion who?
> Knock-knock

---

# 2.1. Async Vs Sync

Good dad-jokes can be asynchronous:

---

![](https://youtu.be/FFym8JwlYxY?t=33)

---

# 2.2. Ports vs Promises

Ports have an asynchronous API. Promises do not.

- Treat JS as a service, but not as an HTTP server
- No request / response pair
- Msg in / Msg out

---
> Wait a second. I thought promises were asynchronous!?

---

# 2.2. Ports vs Promises

Async API and async execution are not the same thing.

