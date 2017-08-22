autoscale: true
text: Lato Bold
header: Lato Black
code: Iosevka

# [fit] A Very Im-port-ant Topic 
or, how I learned to stop worrying and love ports
## Murphy Randle
- Work: [Day One](https://dayoneapp.com)
- Twitter: [@splodingsocks](https://twitter.com/splodingsocks)
- Github: [@splodingsocks](https://twitter.com/splodingsocks)

![](img/title.jpg)

---

# [fit] Story Time
## [fit] or, how this talk was born

![](img/story-time.jpg)

[.footer: Photo by Dariusz Sankowski on Unsplash]

---
[.build-lists: true]

## The Situation
- Client-side database
- Hand-written native code to wrap DB

## The Sadness
- Runtime errors 😭
- No compiler help

[.footer: Story time]
---

## The Conversation
- Mentioned in Slack bad experience with native code
- Mentioned that using ports would be even worse

## The Change of Perspective
- Evan replied
- I had been using an incorrect mental model of ports
- I revised my brain and re-architected

[.footer: Story time]
---

# The Result
- No more native code
- 💸💰🤑💸💰🤑💸💰🤑
- Elm & JS remain separate worlds with separate concerns
- Scaling JS-Elm interaction is simple (a simple pattern is simple to follow)

[.footer: Story time]

---

# Let's do it together

---

TODO: Insert gif of http://pocketjournal.splode.co/ here

---

Our data is stored in IndexedDB, and we need to create, modify, and delete records (for starters)

---
# [fit] Ports

> [They're] like JavaScript-as-a-Service
-- guide.elm-lang.org

---

# Attempt 1

Put in code for one port per operation

---

# JavaScript as a service

- Ports make JavaScript == Service
  - BUT
    - Service `/=` server
    - Ports `/=` HTTP + Promises
